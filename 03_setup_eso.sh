#!/usr/bin/env bash
set -euo pipefail

. ./cfg.sh

echo "=== ESO Bootstrap Starting ==="

echo "========================="
echo "0. Ensuring managed identity: $ESO_IDENTITY_NAME"
echo "========================="

IDENTITY_JSON=$(az identity show \
  --name $ESO_IDENTITY_NAME \
  --resource-group $AKS_RG_NAME \
  2>/dev/null || true)

if [ -z "$IDENTITY_JSON" ]; then
  echo "   Creating identity..."
  az identity create \
    --name $ESO_IDENTITY_NAME \
    --resource-group $AKS_RG_NAME >/dev/null
else
  echo "   Identity already exists"
fi

ESO_CLIENT_ID=$(az identity show \
  --name $ESO_IDENTITY_NAME \
  --resource-group $AKS_RG_NAME \
  --query clientId -o tsv)

ESO_PRINCIPAL_ID=$(az identity show \
  --name $ESO_IDENTITY_NAME \
  --resource-group $AKS_RG_NAME \
  --query principalId -o tsv)

echo "   ESO_CLIENT_ID=$ESO_CLIENT_ID"


echo "========================="
echo "1. Create namespace"
echo "-> Creating namespace: $ESO_NAMESPACE"
echo "========================="
kubectl create namespace $ESO_NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

echo "========================="
echo "2. Install ESO via Helm"
echo "-> Installing External Secrets Operator"
echo "========================="
helm repo add external-secrets https://charts.external-secrets.io >/dev/null
helm repo update >/dev/null

helm upgrade --install external-secrets \
  external-secrets/external-secrets \
  -n $ESO_NAMESPACE \
  --set serviceAccount.annotations."azure\.workload\.identity/client-id"="$ESO_CLIENT_ID"

echo "========================="
echo "4. Key Vault permissions"
echo "-> Assigning Key Vault RBAC role"
echo "========================="

echo "fetching KV ID"
KV_SCOPE=$(az keyvault show \
  --name $KV_NAME \
  --query id -o tsv)

echo "adding Role: Key Vault Secrets User (read secrets only)"
az role assignment create \
  --assignee-object-id $ESO_PRINCIPAL_ID \
  --assignee-principal-type ServicePrincipal \
  --role "Key Vault Secrets User" \
  --scope $KV_SCOPE

echo "========================="
echo "5. OIDC issuer"
echo "-> Fetching OIDC issuer"
echo "========================="

OIDC_ISSUER=$(az aks show \
  --resource-group $AKS_RG_NAME \
  --name $AKS_NAME \
  --query "oidcIssuerProfile.issuerUrl" -o tsv)

echo "   OIDC=$OIDC_ISSUER"

echo "========================="
echo "6. Federated Credential (idempotent safe replace)"
echo "-> Creating federated credential"
echo "========================="

EXISTS=$(az identity federated-credential list \
  --identity-name $ESO_IDENTITY_NAME \
  --resource-group $AKS_RG_NAME \
  --query "[?name=='$ESO_FED_CRED_NAME'] | length(@)")

if [ "$EXISTS" != "0" ]; then
  echo "   Federated credential already exists, skipping"
else
  az identity federated-credential create \
    --name $ESO_FED_CRED_NAME \
    --identity-name $ESO_IDENTITY_NAME \
    --resource-group $AKS_RG_NAME \
    --issuer $OIDC_ISSUER \
    --subject "system:serviceaccount:${ESO_NAMESPACE}:external-secrets" \
    --audience api://AzureADTokenExchange >/dev/null
fi

echo "========================="
echo "7. ClusterSecretStore"
echo "-> Creating ClusterSecretStore"
echo "========================="

cat <<EOF | kubectl apply -f -
apiVersion: external-secrets.io/v1
kind: ClusterSecretStore
metadata:
  name: azure-keyvault
spec:
  provider:
    azurekv:
      vaultUrl: https://${KV_NAME}.vault.azure.net/
      authType: WorkloadIdentity
      serviceAccountRef:
        name: external-secrets
        namespace: ${ESO_NAMESPACE}
EOF

echo "=== ESO Bootstrap Complete ==="
echo ""
echo "Next validation:"
echo "  kubectl get pods -n $ESO_NAMESPACE"
echo "  kubectl get clustersecretstore"