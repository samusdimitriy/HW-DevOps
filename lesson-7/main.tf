locals {
  region                      = "us-west-2"
  base_name                   = "lesson-7"
  vpc_cidr                    = "10.0.0.0/16"
  public_subnet_cidrs         = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_cidrs        = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones          = ["us-west-2a", "us-west-2b", "us-west-2c"]
  jenkins_namespace           = "jenkins"
  argocd_namespace            = "argocd"
  aws_credentials_secret_name = "jenkins-aws-creds"
  gitops_repo_url             = "https://github.com/samusdimitriy/HW-DevOps.git"
  gitops_repo_revision        = "lesson-8-9"
  gitops_repo_path            = "lesson-7/charts/django-app"
}

locals {
  argocd_applications = [
    {
      name                  = "django-app"
      project               = "default"
      repo_url              = local.gitops_repo_url
      target_revision       = local.gitops_repo_revision
      path                  = local.gitops_repo_path
      destination_namespace = "django-app"
      create_namespace      = true
      helm_value_files      = []
      helm_parameters       = {}
      sync_policy = {
        automated = {
          prune       = true
          self_heal   = true
          allow_empty = false
        }
        sync_options = [
          "PrunePropagationPolicy=foreground",
          "RespectIgnoreDifferences=true"
        ]
      }
    }
  ]

  argocd_repositories = [
    {
      name = "hw-devops"
      url  = local.gitops_repo_url
      type = "git"
    }
  ]
}

# Підключаємо модуль для S3 та DynamoDB
module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "${local.base_name}-tf-state-431969328609"
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
  desired_size       = 3
  min_size           = 2
  max_size           = 5
  instance_types     = ["t3.small"]

  additional_tags = {
    Project = "django-app"
  }
}

module "jenkins" {
  source                      = "./modules/jenkins"
  namespace                   = local.jenkins_namespace
  release_name                = "${local.base_name}-jenkins"
  aws_region                  = local.region
  aws_credentials_secret_name = local.aws_credentials_secret_name
  admin_user                  = "admin"
  admin_password              = "ChangeMe123!"
  service_type                = "LoadBalancer"
  persistence_enabled         = false
  chart_version               = "5.3.2"
  controller_image_tag        = "lts-jdk17"

  providers = {
    helm       = helm.eks
    kubernetes = kubernetes.eks
  }

  depends_on = [module.eks]
}

module "argo_cd" {
  source              = "./modules/argo_cd"
  namespace           = local.argocd_namespace
  release_name        = "${local.base_name}-argocd"
  server_service_type = "LoadBalancer"
  applications        = local.argocd_applications
  repositories        = local.argocd_repositories

  providers = {
    helm       = helm.eks
    kubernetes = kubernetes.eks
  }

  depends_on = [module.eks]
}
