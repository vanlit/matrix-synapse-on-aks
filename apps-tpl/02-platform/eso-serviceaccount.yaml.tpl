apiVersion: v1
kind: ServiceAccount
metadata:
  name: external-secrets
  namespace: ${ESO_NAMESPACE}

  labels:
    azure.workload.identity/use: "true"

  annotations:
    azure.workload.identity/client-id: ${TF_OUT_eso_client_id}
