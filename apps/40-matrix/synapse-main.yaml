apiVersion: apps/v1
kind: Deployment
metadata:
  name: synapse-main
  namespace: matrix

spec:
  replicas: 1

  selector:
    matchLabels:
      app: synapse-main

  template:
    metadata:
      labels:
        app: synapse-main

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

          ports:
            - name: http
              containerPort: 8008

            - name: replication
              containerPort: 9093

          volumeMounts:
            - name: config
              mountPath: /etc/synapse

            - name: secrets
              mountPath: /run/synapse-secrets
              readOnly: true

            - name: data
              mountPath: /data

      volumes:
        - name: config
          configMap:
            name: synapse-config

        - name: secrets
          secret:
            secretName: synapse-secrets

        - name: data
          emptyDir: {}

---
apiVersion: v1
kind: Service
metadata:
  name: synapse-main
  namespace: matrix

spec:
  selector:
    app: synapse-main

  ports:
    - name: http
      port: 8008
      targetPort: http

    - name: replication
      port: 9093
      targetPort: replication

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: synapse-client-reader
  namespace: matrix

spec:
  replicas: 1

  selector:
    matchLabels:
      app: synapse-client-reader

  template:
    metadata:
      labels:
        app: synapse-client-reader

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
            - /etc/synapse/client-worker.yaml

          ports:
            - name: http
              containerPort: 8081

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

---
apiVersion: v1
kind: Service
metadata:
  name: synapse-client-reader
  namespace: matrix

spec:
  selector:
    app: synapse-client-reader

  ports:
    - name: http
      port: 8081
      targetPort: http

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: synapse-federation-reader
  namespace: matrix

spec:
  replicas: 1

  selector:
    matchLabels:
      app: synapse-federation-reader

  template:
    metadata:
      labels:
        app: synapse-federation-reader

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
            - /etc/synapse/federation-worker.yaml

          ports:
            - name: http
              containerPort: 8082

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
