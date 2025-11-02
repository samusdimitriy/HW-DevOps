# Lesson 5 — AWS VPC Module with Terraform

У п'ятому уроці ми продовжуємо тему віддаленого стейту та будуємо мережеву інфраструктуру AWS на базі окремого модуля VPC.

## Структура каталогу

```
lesson-5/
├── backend.tf
├── main.tf
├── outputs.tf
├── providers.tf
├── modules/
│   ├── s3-backend/
│   │   ├── dynamodb.tf
│   │   ├── outputs.tf
│   │   ├── s3.tf
│   │   └── variables.tf
│   ├── vpc/
│   │   ├── outputs.tf
│   │   ├── routes.tf
│   │   ├── variables.tf
│   │   └── vpc.tf
│   └── ecr/
│       ├── ecr.tf
│       ├── outputs.tf
│       └── variables.tf
└── README.md
```

## Налаштування AWS CLI

```bash
aws configure --profile terraform-admin
export AWS_PROFILE=terraform-admin
aws sts get-caller-identity
```

## Створення інфраструктури

```bash
cd lesson-5
terraform init
terraform plan
terraform apply
```

> Ім'я бакета `tf-state-523369939948-lesson-5` повинне залишатися глобально унікальним. За потреби змініть його у `main.tf` та `backend.tf`.
> Таблиця блокувань за замовчуванням називається `terraform-locks-lesson-5` — якщо вона вже існує, вкажіть іншу назву в цих самих файлах.

## Міграція стейту до S3

Після першого застосування додайте `backend.tf` (або скоригуйте існуючий) та виконайте:

```bash
terraform init -migrate-state
```

## Перевірка ресурсів

- S3: <https://s3.console.aws.amazon.com/s3/home?region=us-west-2>
- DynamoDB: <https://us-west-2.console.aws.amazon.com/dynamodbv2/home?region=us-west-2#tables:>
- VPC: <https://us-west-2.console.aws.amazon.com/vpc/home?region=us-west-2#vpcs:>
- Subnets: <https://us-west-2.console.aws.amazon.com/vpc/home?region=us-west-2#subnets:>
- NAT Gateway: <https://us-west-2.console.aws.amazon.com/vpc/home?region=us-west-2#natGatewayList:>
- ECR: <https://us-west-2.console.aws.amazon.com/ecr/home?region=us-west-2#/repositories>

## Прибирання

```bash
terraform destroy
```

Після міграції бекенду локальні файли `.terraform/` та `terraform.tfstate*` слід видалити чи додати у `.gitignore`.

## Примітки

- Модуль `s3-backend` створює версіонований бакет для Terraform state та DynamoDB-таблицю для блокувань.
- Модуль `vpc` розгортає VPC, 3 публічні й 3 приватні підмережі, Internet Gateway, NAT Gateway та окремі маршрутні таблиці з необхідними маршрутами.
- Модуль `ecr` створює репозиторій ECR із увімкненим скануванням образів та політикою доступу для поточного AWS акаунта.
