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

        metrics:
          prometheus:
            enabled: true

        # for ACME
        additionalArguments:
          - "--certificatesresolvers.le.acme.email=admin@${TOP_DOMAIN}"
          - "--certificatesresolvers.le.acme.storage=/data/acme.json"
          # FORCE HTTP-01 ONLY
          - "--certificatesresolvers.le.acme.httpchallenge.entrypoint=web"
          - "--certificatesresolvers.le.acme.tlschallenge=false"

        persistence:
          enabled: true
          path: /data
          size: 128Mi

        # Fix ACME permissions (Traefik runs as UID 65532)
        podSecurityContext:
          fsGroup: 65532

        deployment:
          initContainers:
            - name: volume-permissions
              image: busybox:1.36
              command:
                - sh
                - -c
                - |
                  touch /data/acme.json &&
                  chmod 600 /data/acme.json &&
                  chown 65532:65532 /data/acme.json
              volumeMounts:
                - name: data
                  mountPath: /data

  destination:
    server: https://kubernetes.default.svc
    namespace: traefik

  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true