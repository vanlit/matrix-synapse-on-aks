#!/usr/bin/env bash
set -euo pipefail

. ./cfg.sh

echo "========================================"
echo "Traefik Installation"
echo "========================================"
echo

echo "1 - Granting AKS access to Azure Public IP..."

AKS_PRINCIPAL_ID=$(
  az aks show \
    --resource-group "$AKS_RG_NAME" \
    --name "$AKS_NAME" \
    --query identity.principalId \
    -o tsv
)

PUBLIC_IP_ID=$(
  az network public-ip show \
    --resource-group "$AKS_RG_NAME" \
    --name "$TRAEFIK_PUBLIC_IP_NAME" \
    --query id \
    -o tsv
)

EXISTING_ASSIGNMENT_COUNT=$(
  az role assignment list \
    --assignee-object-id "$AKS_PRINCIPAL_ID" \
    --scope "$PUBLIC_IP_ID" \
    --query "[?roleDefinitionName=='Network Contributor'] | length(@)" \
    -o tsv
)

if [ "$EXISTING_ASSIGNMENT_COUNT" -eq 0 ]; then
  echo "Creating Network Contributor assignment..."

  az role assignment create \
    --assignee-object-id "$AKS_PRINCIPAL_ID" \
    --assignee-principal-type ServicePrincipal \
    --role "Network Contributor" \
    --scope "$PUBLIC_IP_ID" \
    >/dev/null

else
  echo "Network Contributor assignment already exists."
fi


echo "2 - Resolving Public previously-created IP for traefik..."

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

echo "3 - Creating namespace..."

kubectl create namespace "$TRAEFIK_NAMESPACE" \
  --dry-run=client -o yaml | kubectl apply -f -

echo

echo "4 - Adding Helm repo..."

helm repo add traefik https://traefik.github.io/charts >/dev/null 2>&1 || true
helm repo update >/dev/null

echo

echo "5 - Installing Traefik..."


# for azure, instead of --set service.spec.loadBalancerIP="$PUBLIC_IP", using the metadata fields, expecting traefik to catch that
helm upgrade --install traefik traefik/traefik \
  --namespace "$TRAEFIK_NAMESPACE" \
  --set service.type=LoadBalancer \
  --set service.annotations."service\.beta\.kubernetes\.io/azure-pip-name"="$TRAEFIK_PUBLIC_IP_NAME" \
  --set service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-resource-group"="$AKS_RG_NAME" \
  --set ingressRoute.dashboard.enabled=true \
  --set metrics.prometheus.enabled=true

echo
echo
echo "6 - Waiting for Traefik pod readiness..."

kubectl wait \
  --for=condition=Ready \
  pod \
  --all \
  -n "$TRAEFIK_NAMESPACE" \
  --timeout=300s

echo
echo "7 - Waiting for deployment availability..."

kubectl rollout status deployment/traefik \
  -n "$TRAEFIK_NAMESPACE" \
  --timeout=300s

echo
echo "8 - Waiting for LoadBalancer IP assignment..."

for i in $(seq 1 60); do

  LB_IP=$(
    kubectl get svc traefik \
      -n "$TRAEFIK_NAMESPACE" \
      -o jsonpath='{.status.loadBalancer.ingress[0].ip}' \
      2>/dev/null || true
  )

  if [ -n "$LB_IP" ]; then
    break
  fi

  echo "Waiting for Azure LoadBalancer..."
  sleep 5

done

if [ -z "${LB_IP:-}" ]; then
  echo "ERROR: LoadBalancer IP was not assigned"
  exit 1
fi

echo "LoadBalancer IP assigned:"
echo "  $LB_IP"

if [ "$LB_IP" != "$PUBLIC_IP" ]; then
  echo
  echo "ERROR: Unexpected IP assigned"
  echo "Expected: $PUBLIC_IP"
  echo "Actual:   $LB_IP"
  exit 1
fi

echo

echo "========================================"
echo "Traefik READY"
echo "========================================"
echo
echo "External IP:"
echo "  $PUBLIC_IP"
echo