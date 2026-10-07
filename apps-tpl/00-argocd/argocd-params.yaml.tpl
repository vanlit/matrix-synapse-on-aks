apiVersion: v1
kind: ConfigMap

metadata:
  name: argocd-cmd-params-cm
  namespace: ${TF_VAR_argocd_namespace}

data:
  server.insecure: "true"
