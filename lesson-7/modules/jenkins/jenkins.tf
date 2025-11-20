locals {
  rendered_values = templatefile("${path.module}/values.yaml", {
    namespace      = var.namespace
    release_name   = var.release_name
    service_type   = var.service_type
    persistence    = var.persistence_enabled
    storage_class  = var.storage_class
    admin_user     = var.admin_user
    admin_password = var.admin_password
    controller_tag = var.controller_image_tag
    kaniko_image   = var.kaniko_image
    git_image      = var.git_image
    aws_region     = var.aws_region
    aws_secret     = var.aws_credentials_secret_name
  })

  additional_values = length(trimspace(var.additional_values)) > 0 ? [var.additional_values] : []
}

resource "kubernetes_namespace" "jenkins" {
  metadata {
    name = var.namespace
    labels = {
      app = "jenkins"
    }
  }
}

resource "helm_release" "jenkins" {
  name             = var.release_name
  repository       = var.helm_repository
  chart            = var.chart_name
  version          = var.chart_version
  namespace        = kubernetes_namespace.jenkins.metadata[0].name
  create_namespace = false
  wait             = true
  timeout          = 900

  values = concat([local.rendered_values], local.additional_values)

  depends_on = [kubernetes_namespace.jenkins]
}
