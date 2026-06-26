#!/usr/bin/env bash
set -euo pipefail

. ./cfg.sh

echo "Rendering ArgoCD manifest..."

envsubst < argocd/root-app.yaml.tpl | kubectl apply -f -