apiVersion: v1
kind: ConfigMap
metadata:
  name: synapse-config
  namespace: matrix

data:
  homeserver.yaml: |
    server_name: "${TF_OUT_synapse_server_name}"

    public_baseurl: "${TF_OUT_matrix_base_url}/"

    pid_file: /data/homeserver.pid

    listeners:
      - port: 8008
        bind_addresses:
          - "0.0.0.0"
        type: http
        x_forwarded: true
        resources:
          - names:
              - client
              - federation

      - port: 9093
        bind_addresses:
          - "0.0.0.0"
        type: http
        resources:
          - names:
              - replication

    database:
      name: psycopg2
      args:
        user: matrix
        password_path: /run/synapse-secrets/postgres_password
        database: synapse
        host: matrix-rw.cloudnative-pg.svc.cluster.local
        port: 5432

    log_config: /etc/synapse/log.config

    media_store_path: /data/media_store

    signing_key_path: /data/signing.key

    registration_shared_secret_path: /run/synapse-secrets/registration_shared_secret
    macaroon_secret_key_path: /run/synapse-secrets/macaroon_secret_key
    form_secret_path: /run/synapse-secrets/form_secret

    turn_uris:
      - "turn:${TF_OUT_turn_base_domain}:3478?transport=udp"
      - "turn:${TF_OUT_turn_base_domain}:3478?transport=tcp"
      - "turns:${TF_OUT_turn_base_domain}:5349?transport=tcp"

    turn_shared_secret_path: /run/synapse-secrets/turn_shared_secret
    turn_user_lifetime: 1h

    redis:
      enabled: true
      host: redis-master.redis.svc.cluster.local
      port: 6379
      password_path: /run/synapse-secrets/redis_password

    worker_replication_secret_path: /run/synapse-secrets/worker_replication_secret

    run_background_tasks_on: background_worker

    media_instance_running_background_jobs: media_worker

    enable_media_repo: false

    experimental_features:
      msc3266_enabled: true
      msc4143_enabled: true
      msc4222_enabled: true

    matrix_rtc:
      transports:
        - type: livekit
          livekit_service_url: "${TF_OUT_livekit_base_url}/livekit/jwt"

    trusted_key_servers:
      - server_name: "matrix.org"

  log.config: |
    version: 1

    formatters:
      precise:
        format: "%(asctime)s - %(name)s - %(lineno)d - %(levelname)s - %(request)s - %(message)s"

    handlers:
      console:
        class: logging.StreamHandler
        formatter: precise
        stream: ext://sys.stdout

    loggers:
      synapse:
        level: INFO

    root:
      level: INFO
      handlers:
        - console

  client-worker.yaml: |
    worker_app: synapse.app.generic_worker
    worker_name: client_reader

    worker_replication_host: synapse-main.matrix.svc.cluster.local
    worker_replication_http_port: 9093

    worker_listeners:
      - type: http
        port: 8081
        x_forwarded: true
        resources:
          - names:
              - client

    worker_log_config: /etc/synapse/log.config

  federation-worker.yaml: |
    worker_app: synapse.app.generic_worker
    worker_name: federation_reader

    worker_replication_host: synapse-main.matrix.svc.cluster.local
    worker_replication_http_port: 9093

    worker_listeners:
      - type: http
        port: 8082
        x_forwarded: true
        resources:
          - names:
              - federation

    worker_log_config: /etc/synapse/log.config

  background-worker.yaml: |
    worker_app: synapse.app.generic_worker
    worker_name: background_worker

    worker_replication_host: synapse-main.matrix.svc.cluster.local
    worker_replication_http_port: 9093

    worker_log_config: /etc/synapse/log.config

  media-worker.yaml: |
    worker_app: synapse.app.media_repository
    worker_name: media_worker

    worker_replication_host: synapse-main.matrix.svc.cluster.local
    worker_replication_http_port: 9093

    worker_listeners:
      - type: http
        port: 8085
        x_forwarded: true
        resources:
          - names:
              - media

    worker_log_config: /etc/synapse/log.config

---
apiVersion: v1
kind: Secret
metadata:
  name: synapse-worker-replication
  namespace: matrix

type: Opaque

stringData:
  worker_replication_secret: "REPLACE_WITH_KV_SECRET"
