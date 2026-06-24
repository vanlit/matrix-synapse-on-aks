#!/usr/bin/env bash
set -euo pipefail

. ./cfg.sh

az network public-ip create \
  --resource-group "$AKS_RG_NAME" \
  --name "$TRAEFIK_PUBLIC_IP_NAME" \
  --sku Standard \
  --allocation-method Static

TRAEFIK_PUBLIC_IP=$(
  az network public-ip show \
    --resource-group "$AKS_RG_NAME" \
    --name "$TRAEFIK_PUBLIC_IP_NAME" \
    --query ipAddress \
    -o tsv
)

echo "Traefik Public IP: $TRAEFIK_PUBLIC_IP"

az network public-ip show \
  --resource-group "$AKS_RG_NAME" \
  --name "$TRAEFIK_PUBLIC_IP_NAME" \
  --query "{ip:ipAddress,sku:sku.name}"