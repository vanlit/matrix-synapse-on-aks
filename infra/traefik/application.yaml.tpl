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

        certificatesResolvers:
          myresolver:
            acme:
              email: "contact@wanil.pl"
              storage: "/data/acme.json"       # Path to store the certificate information.
              httpChallenge:
                # Entry point to use during the ACME HTTP-01 challenge.
                entryPoint: "web"

  destination:
    server: https://kubernetes.default.svc
    namespace: traefik

  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true