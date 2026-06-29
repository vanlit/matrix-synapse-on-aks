#!/usr/bin/env bash
set -euo pipefail

. ./cfg.sh

: "${KV_NAME:?KV_NAME is not set}"

echo "Using Key Vault: $KV_NAME"

echo "Warning, this automation does not currently support non-dockerhub registries"
echo "However, the config includes the registry address, too."
echo "If You need to pull the images from another registry, please edit this script before proceeding"

read -rp "DockerHub username: " DOCKER_USER
read -rsp "DockerHub password/token: " DOCKER_PASS
echo

echo "Writing secrets to Azure Key Vault..."

echo "storign $KV_DOCKERSRC_SERVER ..."
az keyvault secret set \
  --vault-name "$KV_NAME" \
  --name "$KV_DOCKERSRC_SERVER" \
  --value "https://index.docker.io/v2/" > /dev/null

echo "storign $KV_DOCKERSRC_USERNAME ..."
az keyvault secret set \
  --vault-name "$KV_NAME" \
  --name "$KV_DOCKERSRC_USERNAME" \
  --value "$DOCKER_USER" > /dev/null

echo "storign $KV_DOCKERSRC_PASSWORD ..."
az keyvault secret set \
  --vault-name "$KV_NAME" \
  --name "$KV_DOCKERSRC_PASSWORD" \
  --value "$DOCKER_PASS" > /dev/null

echo "Done."