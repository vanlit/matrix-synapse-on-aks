apiVersion: traefik.io/v1alpha1
kind: IngressRoute
metadata:
  name: argocd
  namespace: ${ARGO_NS}

spec:
  entryPoints:
    - websecure

  routes:
    - kind: Rule
      match: Host(`argocd.${TOP_DOMAIN}`)
      services:
        - name: argocd-server
          port: 80

  tls:
    certResolver: le