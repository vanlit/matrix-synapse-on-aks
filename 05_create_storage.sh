#!/usr/bin/env bash
set -euo pipefail

. ./cfg.sh

az storage account create \
  --name "$STORAGE_ACCOUNT_NAME" \
  --resource-group "$AKS_RG_NAME" \
  --location "$REGION" \
  --sku Standard_LRS \
  --kind StorageV2

STORAGE_KEY=$(
  az storage account keys list \
    --account-name "$STORAGE_ACCOUNT_NAME" \
    --resource-group "$AKS_RG_NAME" \
    --query '[0].value' \
    -o tsv
)

az storage container create \
  --account-name "$STORAGE_ACCOUNT_NAME" \
  --name "$BLOB_MEDIA_CONTAINER" \
  --auth-mode login

az storage container create \
  --account-name "$STORAGE_ACCOUNT_NAME" \
  --name "$BLOB_WAL_CONTAINER" \
  --auth-mode login

az storage container create \
  --account-name "$STORAGE_ACCOUNT_NAME" \
  --name "$BLOB_BACKUP_CONTAINER" \
  --auth-mode login

az storage container list \
  --account-name "$STORAGE_ACCOUNT_NAME" \
  --account-key "$STORAGE_KEY" \
  -o table