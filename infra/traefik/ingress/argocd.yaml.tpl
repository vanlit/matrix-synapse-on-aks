apiVersion: traefik.io/v1alpha1
kind: IngressRoute
metadata:
  name: argocd
  namespace: ${ARGO_NS}

spec:
  entryPoints:
    - web
    - websecure

  routes:
    - match: Host(`argocd.${TOP_DOMAIN}`)
      kind: Rule
      services:
        - name: argocd-server
          port: 80

  tls:
    certResolver: le