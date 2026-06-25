apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: traefik
  namespace: ${ARGO_NS}

spec:
  project: default

  source:
    repoURL: https://traefik.github.io/charts
    chart: traefik
    targetRevision: 41.0.0

    helm:
      values: |
        entryPoints:
          web:
            address: :80
            http:
              redirections:
                entryPoint:
                  to: websecure
                  scheme: https
                  permanent: true
            observability:
              accessLogs: false
              metrics: false
              tracing: false

          websecure:
            address: ":443"

        ingressRoute:
          dashboard:
            enabled: true
            matchRule: Host(`dashboard.docker.localhost`)
            entryPoints:
              - websecure
            middlewares:
              - name: dashboard-auth

  destination:
    server: https://kubernetes.default.svc
    namespace: traefik

  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true