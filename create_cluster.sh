#!/bin/sh

. ./cfg.sh

echo "###"
echo "Creating resrouce group"
echo "###"
az group create \
  --name $AKS_RG_NAME \
  --location $REGION

echo "###"
echo "Creating AKS"
echo "###"
az aks create \
  --resource-group $AKS_RG_NAME \
  --name $AKS_NAME \
  --node-count $CLUSTER_NODE_COUNT \
  --node-vm-size $CLUSTER_NODE_VMSIZE \
  --enable-managed-identity \
  --network-plugin azure \
  --network-plugin-mode overlay \
  --generate-ssh-keys


echo "###"
echo "Getting AKS Creds:"
echo "###"
az aks get-credentials \
  --resource-group $AKS_RG_NAME \
  --name $AKS_NAME