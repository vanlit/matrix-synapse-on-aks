apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: registry-pullsecret
  namespace: ${ARGO_NS}
  annotations:
    argocd.argoproj.io/sync-wave: "10"

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
        key: ${TF_VAR_kv_dockersrc_server_sname}

    - secretKey: username
      remoteRef:
        key: ${TF_VAR_kv_dockersrc_username_sname}

    - secretKey: password
      remoteRef:
        key: ${TF_VAR_kv_dockersrc_passwd_sname}