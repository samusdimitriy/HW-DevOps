locals {
  region               = "us-west-2"
  base_name            = "lesson-7"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_cidrs = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones   = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

# Підключаємо модуль для S3 та DynamoDB
module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "${local.base_name}-tf-state-523369939948"
  table_name  = "${local.base_name}-terraform-locks"
}

# Підключаємо модуль для VPC (використовуємо таку ж мережу, як у попередньому ДЗ)
module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = local.vpc_cidr
  public_subnets     = local.public_subnet_cidrs
  private_subnets    = local.private_subnet_cidrs
  availability_zones = local.availability_zones
  vpc_name           = "${local.base_name}-vpc"
}

# Підключаємо модуль для ECR
module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = "${local.base_name}-django-ecr"
  scan_on_push = true
}

# Створюємо EKS кластер у вже наявній мережі
module "eks" {
  source             = "./modules/eks"
  cluster_name       = "${local.base_name}-eks"
  cluster_version    = "1.29"
  vpc_id             = module.vpc.vpc_id
  vpc_cidr_block     = local.vpc_cidr
  public_subnet_ids  = module.vpc.public_subnets
  private_subnet_ids = module.vpc.private_subnets
  desired_size       = 2
  min_size           = 2
  max_size           = 4
  instance_types     = ["t3.medium"]

  additional_tags = {
    Project = "django-app"
  }
}
