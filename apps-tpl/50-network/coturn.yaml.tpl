apiVersion: apps/v1
kind: Deployment
metadata:
  name: coturn
  namespace: calls

spec:
  replicas: 1

  selector:
    matchLabels:
      app: coturn

  template:
    metadata:
      labels:
        app: coturn

    spec:
      hostNetwork: true
      dnsPolicy: ClusterFirstWithHostNet

      nodeSelector:
        workload: calls

      containers:
        - name: coturn
          image: coturn/coturn:4.18.0

          args:
            - -n
            - --log-file=stdout
            - --fingerprint
            - --no-cli
            - --realm=${TF_VAR_TOP_DOMAIN}
            - --server-name=${TF_OUT_turn_base_domain}
            - --listening-port=3478
            - --tls-listening-port=5349
            - --min-port=49152
            - --max-port=65535
            - --use-auth-secret
            - --static-auth-secret-file=/run/coturn/turn-secret
            - --no-tlsv1
            - --no-tlsv1_1

          ports:
            - name: stun-udp
              containerPort: 3478
              protocol: UDP

            - name: stun-tcp
              containerPort: 3478
              protocol: TCP

            - name: turn-tls
              containerPort: 5349
              protocol: TCP

            - name: relay-udp
              containerPort: 49152
              protocol: UDP

          volumeMounts:
            - name: secret
              mountPath: /run/coturn
              readOnly: true

      volumes:
        - name: secret
          secret:
            secretName: coturn-secret
