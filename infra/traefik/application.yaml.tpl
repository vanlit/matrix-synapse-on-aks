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
        deployment:
          replicas: 1

        # =========================
        # FIX: Explicit entryPoints (CRITICAL for ACME)
        # =========================
        entryPoints:
          web:
            address: ":80"
          websecure:
            address: ":443"

        service:
          type: LoadBalancer
          annotations:
            service.beta.kubernetes.io/azure-pip-name: ${TRAEFIK_PUBLIC_IP_NAME}
            service.beta.kubernetes.io/azure-load-balancer-resource-group: ${AKS_RG_NAME}

        ports:
          web:
            exposedPort: 80
          websecure:
            exposedPort: 443

        ingressRoute:
          dashboard:
            enabled: true

        providers:
          kubernetesCRD:
            enabled: true
          kubernetesIngress:
            enabled: true

        logs:
          general:
            level: INFO

        metrics:
          prometheus:
            enabled: true

        # for ACME
        additionalArguments:
          - "--certificatesresolvers.le.acme.email=admin@${TOP_DOMAIN}"
          - "--certificatesresolvers.le.acme.storage=/data/acme.json"
          - "--certificatesresolvers.le.acme.httpchallenge.entrypoint=web"

        # Persistence for ACME cert storage
        additionalVolumeMounts:
          - name: traefik-acme
            mountPath: /data

        additionalVolumes:
          - name: traefik-acme
            persistentVolumeClaim:
              claimName: traefik-acme

        persistence:
          enabled: true
          path: /data
          size: 128Mi

  destination:
    server: https://kubernetes.default.svc
    namespace: traefik

  syncPolicy:
    automated:
      prune: true
      selfHeal: true

    syncOptions:
      - CreateNamespace=true