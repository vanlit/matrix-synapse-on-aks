apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: matrix-db-auth
  namespace: ${PG_NAMESPACE}

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
        key: $KV_MATRIX_POSTGRES_USERNAME

    - secretKey: password
      remoteRef:
        key: $KV_MATRIX_POSTGRES_PASSWORD