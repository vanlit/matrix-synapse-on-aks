apiVersion: traefik.io/v1alpha1
kind: IngressRoute
metadata:
  name: element-web
  namespace: matrix

spec:
  entryPoints:
    - websecure

  routes:
    - kind: Rule
      match: Host(`element.${TF_VAR_TOP_DOMAIN}`)

      services:
        - name: element-web
          port: 80

  tls:
    certResolver: le

---
apiVersion: traefik.io/v1alpha1
kind: IngressRoute
metadata:
  name: synapse
  namespace: matrix

spec:
  entryPoints:
    - websecure

  routes:
    - kind: Rule
      match: Host(`matrix.${TF_VAR_TOP_DOMAIN}`)

      services:
        - name: synapse-main
          port: 8008

  tls:
    certResolver: le

---
apiVersion: traefik.io/v1alpha1
kind: IngressRoute
metadata:
  name: livekit
  namespace: calls

spec:
  entryPoints:
    - websecure

  routes:
    - kind: Rule
      match: Host(`rtc.${TF_VAR_TOP_DOMAIN}`) && PathPrefix(`/livekit/jwt`)

      services:
        - name: lk-jwt-service
          port: 8080

---
apiVersion: traefik.io/v1alpha1
kind: IngressRoute
metadata:
  name: livekit-signalling
  namespace: calls

spec:
  entryPoints:
    - websecure

  routes:
    - kind: Rule
      match: Host(`rtc.${TF_VAR_TOP_DOMAIN}`) && PathPrefix(`/livekit/sfu`)

      services:
        - name: livekit-server
          port: 7880

  tls:
    certResolver: le
