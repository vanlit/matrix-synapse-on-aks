apiVersion: external-secrets.io/v1
kind: ClusterSecretStore
metadata:
  name: ${ESO_KRESNAME}

  annotations:
    argocd.argoproj.io/sync-wave: "10"

spec:
  provider:
    azurekv:
      authType: WorkloadIdentity

      vaultUrl: ${TF_OUT_azure_keyvault_url}

      serviceAccountRef:
        name: external-secrets
        namespace: ${ESO_NAMESPACE}
