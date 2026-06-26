apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: redis-auth
  namespace: ${REDIS_NAMESPACE}

spec:
  refreshInterval: 1h

  secretStoreRef:
    kind: ClusterSecretStore
    name: ${ESO_KRESNAME}

  target:
    name: redis-auth
    creationPolicy: Owner

  data:
    - secretKey: redis-password
      remoteRef:
        key: ${KV_REDIS_PASSWORD}