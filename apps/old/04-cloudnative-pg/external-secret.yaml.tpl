apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: matrix-db-auth
  namespace: ${PG_NAMESPACE}
  annotations:
    argocd.argoproj.io/sync-wave: "20"

spec:
  refreshInterval: 1h

  secretStoreRef:
    kind: ClusterSecretStore
    name: ${ESO_KRESNAME}

  target:
    name: matrix-db-auth
    creationPolicy: Owner
    template:
      type: kubernetes.io/basic-auth

  data:
    - secretKey: username
      remoteRef:
        key: ${TF_VAR_kv_matrix_postgres_username}

    - secretKey: password
      remoteRef:
        key: ${TF_VAR_kv_matrix_postgres_password}