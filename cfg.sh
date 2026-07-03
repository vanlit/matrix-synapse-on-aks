#!/bin/sh

export TF_VAR_environment=prod3
export TF_VAR_location=westeurope
export TF_VAR_TOP_DOMAIN=wanil.pl

export TF_VAR_aks_node_vm_size=Standard_D4s_v5
export TF_VAR_kv_name_postfix="1"

export TF_VAR_eso_identity_name="eso-identity"
export TF_VAR_eso_federated_credential_name="eso-federated-credential"
export ESO_KRESNAME="azure-keyvault"
export ESO_NAMESPACE="external-secrets"

export TF_VAR_argocd_namespace="argocd-matrix"

export TF_VAR_TRAEFIK_NAMESPACE="traefik"
export REDIS_NAMESPACE="redis"
export POSTGRES_NAMESPACE="cloudnative-pg"

export TF_VAR_kv_dockersrc_server_sname="docker-registry-server"
export TF_VAR_kv_dockersrc_username_sname="docker-registry-username"
export TF_VAR_kv_dockersrc_passwd_sname="docker-registry-password"

export TF_VAR_kv_redis_password_sname="redis-password"
export TF_VAR_kv_matrix_postgres_username="matrix-postgres-username"
export TF_VAR_kv_matrix_postgres_password="postgres-password"
export TF_VAR_kv_synapse_registration_secret="synapse-registration-secret"
export TF_VAR_kv_synapse_macaroon_secret="synapse-macaroon-secret"
export TF_VAR_kv_synapse_form_secret="synapse-form-secret"
export TF_VAR_kv_turn_static_auth_secret="turn-static-auth-secret"
export TF_VAR_kv_authelia_jwt_secret="authelia-jwt-secret"
export TF_VAR_kv_authelia_session_secret="authelia-session-secret"
export TF_VAR_kv_authelia_storage_encryption_key="authelia-storage-encryption-key"
