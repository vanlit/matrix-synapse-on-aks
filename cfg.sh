#!/bin/sh

export REGION=westeurope

export CLUSTER_NODE_COUNT=1
export AKS_RG_NAME=matrix-rg
export AKS_NAME=matrix-aks
export CLUSTER_NODE_VMSIZE=Standard_D4s_v5

export KV_NAME=$REGION-matrix-kv

export ESO_NAMESPACE="external-secrets"
export ESO_IDENTITY_NAME="eso-identity"
export ESO_FED_CRED_NAME="eso-federation"
