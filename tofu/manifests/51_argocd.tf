###############################################################
# ArgoCD Namespace
###############################################################

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "matrix-argocd"

    labels = {
      "app.kubernetes.io/managed-by" = "opentofu"
    }
  }

  depends_on = [
    azurerm_kubernetes_cluster.main
  ]
}

###############################################################
# ArgoCD
###############################################################

resource "helm_release" "argocd" {

  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"

  namespace = kubernetes_namespace.argocd.metadata[0].name

  create_namespace = false

  wait            = true
  wait_for_jobs   = true
  atomic          = true
  cleanup_on_fail = true

  timeout = 600

  values = [
    file("${path.module}/values/argocd-values.yaml")
  ]

  depends_on = [
    kubernetes_namespace.argocd
  ]
}