apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: synapse-media
  namespace: matrix

spec:
  accessModes:
    - ReadWriteMany

  storageClassName: azurefile-csi

  resources:
    requests:
      storage: 20Gi
