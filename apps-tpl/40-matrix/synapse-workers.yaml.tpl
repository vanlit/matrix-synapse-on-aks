apiVersion: v1
kind: Service
metadata:
  name: synapse-federation-reader
  namespace: matrix

spec:
  selector:
    app: synapse-federation-reader

  ports:
    - name: http
      port: 8082
      targetPort: http

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: synapse-background-worker
  namespace: matrix

spec:
  replicas: 1

  selector:
    matchLabels:
      app: synapse-background-worker

  template:
    metadata:
      labels:
        app: synapse-background-worker

    spec:
      containers:
        - name: synapse
          image: matrixdotorg/synapse:latest

          command:
            - python
            - -m
            - synapse.app.homeserver
            - --config-path
            - /etc/synapse/homeserver.yaml
            - --config-path
            - /etc/synapse/background-worker.yaml

          volumeMounts:
            - name: config
              mountPath: /etc/synapse

            - name: secrets
              mountPath: /run/synapse-secrets
              readOnly: true

      volumes:
        - name: config
          configMap:
            name: synapse-config

        - name: secrets
          secret:
            secretName: synapse-secrets
        - name: media
          persistentVolumeClaim:
            claimName: synapse-media
        - name: media
          mountPath: /data/media_store


