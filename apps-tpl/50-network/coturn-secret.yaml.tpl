apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: coturn-secret
  namespace: calls

spec:
  refreshInterval: 1h

  secretStoreRef:
    kind: ClusterSecretStore
    name: ${ESO_KRESNAME}

  target:
    name: coturn-secret
    creationPolicy: Owner

  data:
    - secretKey: turn-secret
      remoteRef:
        key: ${TF_VAR_kv_turn_static_auth_secret}
