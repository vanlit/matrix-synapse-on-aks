###############################################################
# Root ArgoCD Application
###############################################################

resource "kubernetes_manifest" "argocd_root_app" {

  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind = "Application"
    metadata = {
      name = "root"
      namespace = kubernetes_namespace.argocd.metadata[0].name
    }

    spec = {
      project = "default"
      source = {
        repoURL        = var.gitops_repository
        targetRevision = var.gitops_revision
        path = "apps/00-argocd"
      }

      destination = {
        server = "https://kubernetes.default.svc"
        namespace = kubernetes_namespace.argocd.metadata[0].name
      }

      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }

        syncOptions = [
          "CreateNamespace=true"
        ]
      }
    }
  }

  depends_on = [
    helm_release.argocd
  ]
}