#!/bin/sh

. ./cfg.sh

az keyvault create \
  --name $KV_NAME \
  --resource-group $AKS_RG_NAME \
  --location $REGION