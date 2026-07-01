apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: cloudnative-pg
  namespace: ${ARGO_NS}

spec:
  project: default

  source:
    repoURL: https://cloudnative-pg.github.io/charts
    chart: cloudnative-pg
    targetRevision: 0.26.0

    helm:
      values: |
        crds:
          create: true

        monitoring:
          podMonitorEnabled: true

        config:
          clusterWide: true

  destination:
    server: https://kubernetes.default.svc
    namespace: ${POSTGRES_NAMESPACE}

  syncPolicy:
    automated:
      prune: true
      selfHeal: true

    syncOptions:
      - CreateNamespace=true