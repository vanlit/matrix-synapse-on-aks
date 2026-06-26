apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: registry-pullsecret
  namespace: ${ARGO_NS}

spec:
  refreshInterval: 1h

  secretStoreRef:
    kind: ClusterSecretStore
    name: azure-keyvault

  target:
    name: registry-pullsecret
    template:
      type: kubernetes.io/dockerconfigjson
      data:
        .dockerconfigjson: |
          {
            "auths": {
              "{{ .server }}": {
                "username": "{{ .username }}",
                "password": "{{ .password }}",
                "auth": "{{ printf "%s:%s" .username .password | b64enc }}"
              }
            }
          }
        username: "{{ .username }}"
        password: "{{ .password }}"

  data:
    - secretKey: server
      remoteRef:
        key: ${KV_DOCKERSRC_SERVER}

    - secretKey: username
      remoteRef:
        key: ${KV_DOCKERSRC_USERNAME}

    - secretKey: password
      remoteRef:
        key: ${KV_DOCKERSRC_PASSWORD}