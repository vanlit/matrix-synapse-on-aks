apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: authelia
  namespace: ${TF_VAR_argocd_namespace}

  annotations:
    argocd.argoproj.io/sync-wave: "0"

spec:
  project: default

  source:
    repoURL: https://charts.authelia.com
    chart: authelia
    targetRevision: 0.10.42

    helm:
      values: |
        pod:
          kind: Deployment
          replicas: 1

        service:
          type: ClusterIP
          port: 80

        configMap:
          enabled: true

        persistence:
          enabled: true
          size: 2Gi

        config:
          theme: auto

          server:
            address: "tcp://0.0.0.0:9091"

          log:
            level: info

          authentication_backend:
            file:
              path: /config/users_database.yml

          access_control:
            default_policy: deny

          session:
            cookies:
              - name: authelia_session
                domain: ${TF_VAR_TOP_DOMAIN}
                authelia_url: ${TF_OUT_authelia_base_url}

          storage:
            local:
              path: /data/db.sqlite3

          notifier:
            filesystem:
              filename: /data/notifications.txt

  destination:
    server: https://kubernetes.default.svc
    namespace: authelia

  syncPolicy:
    automated:
      prune: true
      selfHeal: true

    syncOptions:
      - CreateNamespace=true
