apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: matrix
  namespace: ${POSTGRES_NAMESPACE}

  annotations:
    argocd.argoproj.io/sync-wave: "0"

spec:
  instances: 1

  storage:
    size: 20Gi

  bootstrap:
    initdb:
      database: synapse
      owner: matrix

      secret:
        name: matrix-db-auth

  monitoring:
    enablePodMonitor: true
