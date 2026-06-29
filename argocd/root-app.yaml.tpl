apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: root
  namespace: ${ARGO_NS}

spec:
  project: default

  source:
    repoURL: https://github.com/vanlit/matrix-synapse-on-aks.git
    targetRevision: main
    path: infra

    directory:
      recurse: false
      jsonnet: {}
      exclude: "**/*.tpl"

  destination:
    server: https://kubernetes.default.svc
    namespace: ${ARGO_NS}

  syncPolicy:
    automated:
      prune: true
      selfHeal: true

    syncOptions:
      - CreateNamespace=true
      - PrunePropagationPolicy=foreground
      - ApplyOutOfSyncOnly=true
      - RespectIgnoreDifferences=true

  ignoreDifferences:
    - group: argoproj.io
      kind: Application
      jsonPointers:
        - /status
