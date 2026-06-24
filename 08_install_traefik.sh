#!/usr/bin/env bash
set -euo pipefail

. ./cfg.sh

echo "========================================"
echo "Traefik Installation"
echo "========================================"
echo

echo "1 - Resolving Public previously-created IP for traefik..."

PUBLIC_IP=$(
  az network public-ip show \
    --resource-group "$AKS_RG_NAME" \
    --name "$TRAEFIK_PUBLIC_IP_NAME" \
    --query ipAddress \
    -o tsv
)

if [ -z "$PUBLIC_IP" ]; then
  echo "ERROR: Public IP not found"
  exit 1
fi

echo "Public IP: $PUBLIC_IP"
echo

echo "2 - Creating namespace..."

kubectl create namespace "$TRAEFIK_NAMESPACE" \
  --dry-run=client -o yaml | kubectl apply -f -

echo

echo "3 - Adding Helm repo..."

helm repo add traefik https://traefik.github.io/charts >/dev/null 2>&1 || true
helm repo update >/dev/null

echo

echo "4 - Installing Traefik..."

helm upgrade --install traefik traefik/traefik \
  --namespace "$TRAEFIK_NAMESPACE" \
  --set service.type=LoadBalancer \
  --set service.spec.loadBalancerIP="$PUBLIC_IP" \
  --set ingressRoute.dashboard.enabled=true \
  --set metrics.prometheus.enabled=true

echo

echo "5 - Waiting for deployment..."

kubectl rollout status deployment/traefik \
  -n "$TRAEFIK_NAMESPACE" \
  --timeout=300s

echo

echo "6 - Verifying service..."

kubectl get svc \
  -n "$TRAEFIK_NAMESPACE" \
  traefik

echo

echo "========================================"
echo "Traefik READY"
echo "========================================"
echo
echo "External IP:"
echo "  $PUBLIC_IP"
echo