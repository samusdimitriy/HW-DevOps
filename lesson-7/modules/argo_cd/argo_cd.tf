locals {
  rendered_values = templatefile("${path.module}/values.yaml", {
    namespace    = var.namespace
    service_type = var.server_service_type
    annotations  = var.server_service_annotations
  })

  applications_values = yamlencode({
    applications = var.applications
    repositories = var.repositories
  })

  additional_values = length(trimspace(var.values_override)) > 0 ? [var.values_override] : []
}

resource "kubernetes_namespace" "argo" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/name" = "argocd"
    }
  }
}

resource "helm_release" "argocd" {
  name             = var.release_name
  repository       = var.helm_repository
  chart            = var.chart_name
  version          = var.chart_version
  namespace        = kubernetes_namespace.argo.metadata[0].name
  create_namespace = false
  timeout          = 600
  wait             = true

  values = concat([local.rendered_values], local.additional_values)

  depends_on = [kubernetes_namespace.argo]
}

resource "helm_release" "applications" {
  name       = "${var.release_name}-apps"
  chart      = "${path.module}/charts/argocd-apps"
  namespace  = kubernetes_namespace.argo.metadata[0].name
  depends_on = [helm_release.argocd]

  values = [local.applications_values]
}

data "kubernetes_secret" "initial_admin" {
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = kubernetes_namespace.argo.metadata[0].name
  }

  depends_on = [helm_release.argocd]
}
