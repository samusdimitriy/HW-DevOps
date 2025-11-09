# Lesson 7 — EKS + ECR + Helm

## Що створює Terraform

1. **S3 + DynamoDB** для зберігання та блокування Terraform state.
2. **VPC** (CIDR `10.0.0.0/16`) з трьома публічними та трьома приватними підмережами в `us-west-2`.
3. **ECR** репозиторій `lesson-7-django-ecr` для зберігання образів Django застосунку.
4. **EKS** кластер `lesson-7-eks` із керованою групою вузлів (t3.medium, 2–4 ноди) у приватних підмережах.

Схема розміщена в `main.tf`, а модулі — в `lesson-7/modules/*`.

## Як застосувати інфраструктуру

```bash
cd lesson-7
terraform init
terraform workspace select lesson-7 || terraform workspace new lesson-7
terraform apply
```

Після створення кластеру отримаєте всі необхідні вихідні дані (ID VPC, URL ECR, endpoint EKS тощо) з `outputs.tf`.

## Завантаження Docker-образу в ECR

```bash
AWS_REGION=us-west-2
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_REPO=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/lesson-7-django-ecr

aws ecr get-login-password --region ${AWS_REGION} \
  | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

docker build -t lesson-7-django .
docker tag lesson-7-django:latest ${ECR_REPO}:latest
docker push ${ECR_REPO}:latest
```

Вказівку на побудований образ (repo + tag) оновіть у `charts/django-app/values.yaml`.

## Налаштування kubectl та Helm

```bash
aws eks update-kubeconfig --region us-west-2 --name lesson-7-eks

helm upgrade --install django-app charts/django-app \
  --namespace django --create-namespace
```

Chart містить:

- `Deployment` з образом із ECR та підключенням `ConfigMap` через `envFrom`.
- `Service` типу `LoadBalancer` для зовнішнього доступу.
- `HPA` (autoscaling/v2) 2–6 реплік при CPU > 70%.
- `ConfigMap` із середовищем Django (перенесені змінні з теми 4).

Додаткові параметри сервісу, autoscaler'а, ресурсів і конфігурації можна змінити у `values.yaml`.
