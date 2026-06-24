#!/usr/bin/env bash
set -euo pipefail

. ./cfg.sh

TEST_SECRET_NAME="eso-test-secret"
TEST_SECRET_VALUE="hello-matrix-$(date +%s)"

cleanup() {
  echo
  echo "Cleaning up..."

  kubectl delete externalsecret "${TEST_SECRET_NAME}" \
    --ignore-not-found=true >/dev/null 2>&1 || true

  kubectl delete secret "${TEST_SECRET_NAME}" \
    --ignore-not-found=true >/dev/null 2>&1 || true

  az keyvault secret delete \
    --vault-name "${KV_NAME}" \
    --name "${TEST_SECRET_NAME}" \
    >/dev/null 2>&1 || true
}

trap cleanup EXIT

echo "========================================"
echo "ESO End-to-End Validation"
echo "========================================"
echo
echo "Key Vault:           ${KV_NAME}"
echo "Secret Store:        ${ESO_KRESNAME}"
echo "ESO Namespace:       ${ESO_NAMESPACE}"
echo

echo "Checking operator Key Vault permissions..."

MY_OBJECT_ID=$(az ad signed-in-user show --query id -o tsv)

KV_SCOPE=$(az keyvault show \
  --name "${KV_NAME}" \
  --query id \
  -o tsv)

HAS_ROLE=$(
  az role assignment list \
    --assignee "${MY_OBJECT_ID}" \
    --scope "${KV_SCOPE}" \
    --all \
    --query "[?roleDefinitionName=='Key Vault Secrets Officer'] | length(@)" \
    -o tsv
)

if [ "${HAS_ROLE}" = "0" ]; then
  echo "Assigning Key Vault Secrets Officer role to current operator..."

  az role assignment create \
    --assignee-object-id "${MY_OBJECT_ID}" \
    --role "Key Vault Secrets Officer" \
    --scope "${KV_SCOPE}" \
    >/dev/null

  echo "Waiting for RBAC propagation..."
  sleep 30
else
  echo "Operator already has Key Vault Secrets Officer role."
fi

echo

#
# Verify ClusterSecretStore is healthy
#
echo "Checking ClusterSecretStore readiness..."

kubectl wait \
  --for=jsonpath='{.status.conditions[?(@.type=="Ready")].status}'=True \
  "clustersecretstore/${ESO_KRESNAME}" \
  --timeout=60s

echo "ClusterSecretStore is Ready."
echo

#
# Create secret in Key Vault
#
echo "Creating test secret in Azure Key Vault..."

az keyvault secret set \
  --vault-name "${KV_NAME}" \
  --name "${TEST_SECRET_NAME}" \
  --value "${TEST_SECRET_VALUE}" \
  >/dev/null

echo "Created secret '${TEST_SECRET_NAME}'."
echo

#
# Create ExternalSecret
#
echo "Creating ExternalSecret..."

cat <<EOF | kubectl apply -f -
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: ${TEST_SECRET_NAME}
  namespace: default
spec:
  refreshInterval: 1m
  secretStoreRef:
    name: ${ESO_KRESNAME}
    kind: ClusterSecretStore
  target:
    name: ${TEST_SECRET_NAME}
  data:
    - secretKey: value
      remoteRef:
        key: ${TEST_SECRET_NAME}
EOF

#
# Wait for reconciliation
#
echo "Waiting for ExternalSecret readiness..."

kubectl wait \
  --for=jsonpath='{.status.conditions[?(@.type=="Ready")].status}'=True \
  "externalsecret/${TEST_SECRET_NAME}" \
  --timeout=120s

echo "ExternalSecret is Ready."
echo

#
# Verify Secret exists
#
echo "Checking Kubernetes Secret..."

kubectl get secret "${TEST_SECRET_NAME}" >/dev/null

echo "Kubernetes Secret exists."
echo

#
# Validate payload
#
echo "Validating secret value..."

ACTUAL_VALUE=$(
  kubectl get secret "${TEST_SECRET_NAME}" \
    -o jsonpath='{.data.value}' \
  | base64 -d
)

if [ "${ACTUAL_VALUE}" != "${TEST_SECRET_VALUE}" ]; then
  echo
  echo "ERROR: Secret value mismatch"
  echo "Expected: ${TEST_SECRET_VALUE}"
  echo "Actual:   ${ACTUAL_VALUE}"
  exit 1
fi

echo
echo "========================================"
echo "SUCCESS"
echo "========================================"
echo
echo "Verified:"
echo "  Azure Key Vault"
echo "      ↓"
echo "  External Secrets Operator"
echo "      ↓"
echo "  Kubernetes Secret"
echo
echo "Secret value:"
echo "  ${ACTUAL_VALUE}"
echo