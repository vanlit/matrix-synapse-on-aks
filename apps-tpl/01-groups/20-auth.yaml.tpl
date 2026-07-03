apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: auth
  namespace: ${TF_VAR_argocd_namespace}

spec:
  project: default

  source:
    repoURL: https://github.com/vanlit/matrix-synapse-on-aks.git
    targetRevision: main
    path: apps/20-auth
    directory:
      recurse: false
      jsonnet: {}

  destination:
    server: https://kubernetes.default.svc
    namespace: ${TF_VAR_argocd_namespace}

  syncPolicy:
    automated:
      prune: true
      selfHeal: true

    syncOptions:
      - CreateNamespace=true
      - PrunePropagationPolicy=foreground
      - ApplyOutOfSyncOnly=true
      - RespectIgnoreDifferences=true
