apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: redis-auth
  namespace: ${REDIS_NAMESPACE}

  annotations:
    argocd.argoproj.io/sync-wave: "-10"

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
        key: ${TF_VAR_kv_redis_password_sname}
