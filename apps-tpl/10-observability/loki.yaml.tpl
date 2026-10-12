apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: loki
  namespace: ${TF_VAR_argocd_namespace}

spec:
  project: default

  source:
    repoURL: https://grafana.github.io/helm-charts
    chart: loki
    targetRevision: 6.29.0

    helm:
      values: |
        deploymentMode: SingleBinary

        loki:
          auth_enabled: false

          commonConfig:
            replication_factor: 1

          storage:
            type: filesystem

        singleBinary:
          replicas: 1

        read:
          replicas: 0

        write:
          replicas: 0

        backend:
          replicas: 0

        gateway:
          enabled: false

        chunksCache:
          enabled: false

        resultsCache:
          enabled: false

        lokiCanary:
          enabled: false

  destination:
    server: https://kubernetes.default.svc
    namespace: monitoring

  syncPolicy:
    automated:
      prune: true
      selfHeal: true

    syncOptions:
      - CreateNamespace=true
