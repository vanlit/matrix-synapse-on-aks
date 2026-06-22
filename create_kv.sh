#!/bin/sh

. ./cfg.sh

az keyvault create \
  --name $REGION-matrix-kv \
  --resource-group $AKS_RG_NAME \
  --location $REGION