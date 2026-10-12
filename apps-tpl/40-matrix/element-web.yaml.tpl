apiVersion: v1
kind: ConfigMap
metadata:
  name: element-web-config
  namespace: matrix

data:
  config.json: |
    {
      "default_server_name": "${TF_OUT_synapse_server_name}",
      "default_server_config": {
        "m.homeserver": {
          "base_url": "${TF_OUT_matrix_base_url}"
        }
      },
      "brand": "Element"
    }

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: element-web
  namespace: matrix

spec:
  replicas: 1

  selector:
    matchLabels:
      app: element-web

  template:
    metadata:
      labels:
        app: element-web

    spec:
      containers:
        - name: element-web
          image: vectorim/element-web:latest

          ports:
            - name: http
              containerPort: 80

          volumeMounts:
            - name: config
              mountPath: /app/config.json
              subPath: config.json
              readOnly: true

          readinessProbe:
            httpGet:
              path: /
              port: http

          livenessProbe:
            httpGet:
              path: /
              port: http

      volumes:
        - name: config
          configMap:
            name: element-web-config

---
apiVersion: v1
kind: Service
metadata:
  name: element-web
  namespace: matrix

spec:
  selector:
    app: element-web

  ports:
    - name: http
      port: 80
      targetPort: http
