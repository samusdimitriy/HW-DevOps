# Lesson 8-9 — Jenkins + Argo CD GitOps

## Що створює Terraform

1. **S3 бакет + DynamoDB** (`modules/s3-backend`) для зберігання remote state.
2. **VPC** із публічними/приватними підмережами в `us-west-2` (модуль `modules/vpc`).
3. **ECR** репозиторій `lesson-7-django-ecr` (модуль `modules/ecr`).
4. **EKS** кластер `lesson-7-eks` з керованою node group та встановленим **AWS EBS CSI driver** (модуль `modules/eks`).
5. **Jenkins** встановлений через Helm у namespace `jenkins` (модуль `modules/jenkins`). Chart налаштований під Kubernetes agent із pod template `kaniko + git`, JCasC, RBAC та `LoadBalancer` сервісом.
6. **Argo CD** (`modules/argo_cd`) + кастомний Helm-chart `modules/argo_cd/charts/argocd-apps`, який реєструє:
   - Git репозиторій `https://github.com/samusdimitriy/HW-DevOps.git`;
   - Argo CD Application для `lesson-7/charts/django-app` з автоматичним sync/prune.
7. **RDS** універсальний модуль `modules/rds`, який уміє створювати або Aurora cluster, або звичайну RDS інстансу (приклад нижче).

Усі модулі підключені з `lesson-7/main.tf`, а вихідні дані описані в `lesson-7/outputs.tf` (namespaces, ECR URL, Jenkins/Argo креденшели тощо).

## Передумови

- Terraform ≥ 1.6
- AWS CLI + облікові дані з доступом до EKS/ECR/S3/DynamoDB
- kubectl + helm
- Доступ до GitHub репозиторію `HW-DevOps`

Після `terraform apply` потрібен IAM користувач/роль із правами `AmazonEC2ContainerRegistryFullAccess` та `AmazonEKSClusterPolicy` для Jenkins-агента (використовується в секреті нижче).

## Розгортання інфраструктури

```bash
cd lesson-7
terraform init -reconfigure
terraform workspace select lesson-7 || terraform workspace new lesson-7
terraform apply
```

Оновіть локальний kubeconfig та перевірте кластер:

```bash
aws eks update-kubeconfig --region us-west-2 --name lesson-7-eks
kubectl get nodes
```

Після `terraform init` можна вивести корисні дані:

```bash
terraform output ecr_repository_url
terraform output jenkins_namespace
terraform output jenkins_admin_credentials
terraform output argo_cd_namespace
terraform output argo_cd_initial_admin_password
```

## Підготовка секретів та Jenkins

1. **AWS cred secret для Kaniko** – створюється в namespace `jenkins`:

   ```bash
   kubectl -n jenkins create secret generic jenkins-aws-creds \
     --from-literal=aws_access_key_id=AKIA... \
     --from-literal=aws_secret_access_key=xxxxxxxx \
     --dry-run=client -o yaml | kubectl apply -f -
   ```

   Ці змінні підтягнуться в pod template (див. `modules/jenkins/values.yaml`).

2. **GitHub credentials** – у Jenkins створіть `Username with password` (ID `github-token`):
   - Username: `git`
   - Password: fine-grained PAT з доступом до репозиторію `HW-DevOps`, `Contents: Read and write`, `Metadata: Read-only`.
   - ID має співпасти зі значенням `GIT_CREDENTIALS_ID` у `lesson-7/Jenkinsfile`.

3. **Імпорт pipeline** – створіть pipeline, що читає `lesson-7/Jenkinsfile` з гілки `lesson-8-9` цього репозиторію.

## Jenkinsfile: повний CI

`lesson-7/Jenkinsfile` виконує наступні стадії на Kubernetes agent `kaniko`:

1. **Checkout** – завантажує репозиторій у агентський pod.
2. **Prepare metadata** – формує тег `build-$BUILD_NUMBER` та commit message.
3. **Build & Push image** – запускає `/kaniko/executor`, збирає `lesson-7/app/Dockerfile` і пушить у `${ECR_REPOSITORY}` (і тег, і `latest`).
4. **Update Helm chart** – Python-скриптом оновлює `image.repository` та `image.tag` у `lesson-7/charts/django-app/values.yaml`.
5. **Commit changes** – додає файл, виставляє git user/email та робить `git commit` лише якщо є зміни.
6. **Push to Git** – пушить у гілку `lesson-8-9` через GitHub PAT. Відсутність змін автоматично скасовує пуш.

Після кожного пушу Argo CD бачить новий тег у Git та запускає sync.

## Argo CD GitOps

- Helm release `modules/argo_cd` розгортає Argo CD (dex off, server `LoadBalancer`).
- Підлеглий Helm chart `modules/argo_cd/charts/argocd-apps` створює `Repository` + `Application` CR.
- `Application` спостерігає за гілкою `main`, шляхом `lesson-7/charts/django-app`, namespace `django-app`, увімкнено автоматичний sync/prune та `CreateNamespace=true`.

Доступ до UI:

```bash
# якщо порт 8080 зайнятий, оберіть вільний, напр. 8081
kubectl -n argocd port-forward svc/lesson-7-argocd-server 8081:80
# або використайте зовнішній LoadBalancer з terraform output argo_cd_server_hostname
```

Логін: юзер `admin`, пароль із `terraform output argo_cd_initial_admin_password`.

## Helm chart Django застосунку

Chart лежить у `lesson-7/charts/django-app` та містить `Deployment`, `Service`, `ConfigMap`, `HPA`. Основні поля (образ, ресурси, змінні середовища) налаштовуються через `values.yaml`, який оновлює Jenkins pipeline. За потреби chart можна встановити вручну:

```bash
helm upgrade --install django-app lesson-7/charts/django-app \
  --namespace django-app --create-namespace
```

## Приклад використання модуля RDS

```hcl
module "rds" {
  source = "./modules/rds"

  name_prefix           = "lesson-db"
  use_aurora            = true                # false -> звичайна RDS instance
  engine                = "aurora-postgresql" # для звичайної RDS: "postgres"
  engine_version        = "14.10"
  aurora_instance_class = "db.r6g.medium"
  master_username       = "dbadmin"
  master_password       = "ChangeMe123!"

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  allowed_cidrs      = ["10.0.0.0/16"]
}
```

Модуль автоматично створює subnet group, security group, parameter group та видає endpoint/port у виходах.

## Перевірка потоку CI/CD

1. Створіть новий коміт/тег у гілці, запустіть Jenkins pipeline.
2. Переконайтесь, що з'явився новий образ у `ECR` (`aws ecr list-images ...`).
3. Перегляньте Argo CD UI чи `kubectl -n django-app get pods` — має відбутися автоматичне оновлення з новим тегом.

Уся інфраструктура описана в гілці `lesson-8-9` цього репозиторію.
