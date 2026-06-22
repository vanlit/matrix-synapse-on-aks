#!/usr/bin/env bash

set -euo pipefail

REPO_NAME="matrix-platform"

mkdir -p "${REPO_NAME}"

cd "${REPO_NAME}"

# Bootstrap
mkdir -p \
  bootstrap/argocd \
  bootstrap/root-app

# Infrastructure
mkdir -p \
  infrastructure/traefik \
  infrastructure/external-secrets \
  infrastructure/cloudnative-pg \
  infrastructure/redis \
  infrastructure/storage

# Authentication
mkdir -p \
  auth/authelia

# Observability
mkdir -p \
  observability/prometheus \
  observability/grafana \
  observability/loki

# Matrix
mkdir -p \
  matrix/synapse \
  matrix/element \
  matrix/coturn

# Environments
mkdir -p \
  environments/dev \
  environments/poc \
  environments/prod

# Documentation
mkdir -p docs

# Placeholder files
touch \
  README.md \
  docs/architecture.md \
  docs/bootstrap.md \
  docs/disaster-recovery.md \
  docs/secrets.md

touch \
  environments/dev/values.yaml \
  environments/poc/values.yaml \
  environments/prod/values.yaml

touch \
  bootstrap/argocd/README.md \
  bootstrap/root-app/README.md

touch \
  infrastructure/traefik/README.md \
  infrastructure/external-secrets/README.md \
  infrastructure/cloudnative-pg/README.md \
  infrastructure/redis/README.md \
  infrastructure/storage/README.md

touch \
  auth/authelia/README.md

touch \
  observability/prometheus/README.md \
  observability/grafana/README.md \
  observability/loki/README.md

touch \
  matrix/synapse/README.md \
  matrix/element/README.md \
  matrix/coturn/README.md

echo
echo "Repository structure created:"
echo
tree -a .