apiVersion: traefik.io/v1alpha1
kind: IngressRoute
metadata:
  name: argocd
  namespace: ${TF_VAR_argocd_namespace}

spec:
  entryPoints:
    - websecure

  routes:
    - kind: Rule
      match: Host(`argocd.${TF_VAR_TOP_DOMAIN}`)
      services:
        - name: argocd-server
          port: 80

  tls:
    certResolver: le