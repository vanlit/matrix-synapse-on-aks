apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: synapse-secrets
  namespace: matrix

  annotations:
    argocd.argoproj.io/sync-wave: "-20"

spec:
  refreshInterval: 1h

  secretStoreRef:
    kind: ClusterSecretStore
    name: ${ESO_KRESNAME}

  target:
    name: synapse-secrets
    creationPolicy: Owner

  data:
    - secretKey: registration_shared_secret
      remoteRef:
        key: ${TF_VAR_kv_synapse_registration_secret}

    - secretKey: macaroon_secret_key
      remoteRef:
        key: ${TF_VAR_kv_synapse_macaroon_secret}

    - secretKey: form_secret
      remoteRef:
        key: ${TF_VAR_kv_synapse_form_secret}

    - secretKey: turn_shared_secret
      remoteRef:
        key: ${TF_VAR_kv_turn_static_auth_secret}

    - secretKey: postgres_username
      remoteRef:
        key: ${TF_VAR_kv_matrix_postgres_username}

    - secretKey: postgres_password
      remoteRef:
        key: ${TF_VAR_kv_matrix_postgres_password}

    - secretKey: redis_password
      remoteRef:
        key: ${TF_VAR_kv_redis_password_sname}
