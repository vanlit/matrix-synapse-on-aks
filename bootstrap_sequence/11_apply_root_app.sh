#!/usr/bin/env bash
set -euo pipefail

. ./cfg.sh

echo "========================================"
echo "Apply the root app -- the start of gitops"
echo "========================================"
echo

kubectl apply -f ./apps/00-argocd/root-app.yaml
