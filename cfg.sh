#!/bin/sh

export REGION=westeurope
export TOP_DOMAIN=wanil.pl

export CLUSTER_NODE_COUNT=1
export AKS_RG_NAME=matrix-rg
export AKS_NAME=matrix-aks
export CLUSTER_NODE_VMSIZE=Standard_D4s_v5

export KV_NAME=$REGION-matrix-kv

export ESO_KRESNAME="azure-keyvault"
export ESO_NAMESPACE="external-secrets"
export ESO_IDENTITY_NAME="eso-identity"
export ESO_FED_CRED_NAME="eso-federation"


export STORAGE_ACCOUNT_NAME="${REGION}matrixsa"

export BLOB_MEDIA_CONTAINER="synapse-media"
export BLOB_WAL_CONTAINER="postgres-wal"
export BLOB_BACKUP_CONTAINER="postgres-backups"

export TRAEFIK_PUBLIC_IP_NAME="matrix-traefik-ip"

export ARGO_NS="matrix-argocd"

export TRAEFIK_NAMESPACE="traefik"

export REDIS_NAMESPACE="redis"
export POSTGRES_NAMESPACE="cloudnative-pg"

export REDIS_RELEASE_NAME="redis"
export POSTGRES_RELEASE_NAME="cnpg"
