#!/usr/bin/env bash
set -euo pipefail

. ./cfg.sh

echo "Rendering ArgoCD manifests..."

envsubst < infra/traefik/application.yaml.tpl | kubectl apply -f -