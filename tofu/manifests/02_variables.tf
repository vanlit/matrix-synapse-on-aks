variable "project" {
  description = "Project name used as global prefix for all resources"
  type        = string
  default     = "matrix"
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
  default     = "prod2"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "westeurope"
}

variable "tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default = {
    terraformed_by = "opentofu"
    managed_by     = "argocd"
    project        = var.project
  }
}

variable "aks_node_count_min" {
  type    = number
  default = 1
}
variable "aks_node_count_max" {
  type    = number
  default = 1
}

variable "aks_node_vm_size" {
  type    = string
  default = "Standard_D4s_v5"
}

variable "keyvault_sku" {
  type    = string
  default = "standard"
}

variable "keyvault_name_postfix" {
  type    = string
  default = "1"
}

variable "storage_account_tier" {
  type    = string
  default = "Standard"
}

variable "storage_replication_type" {
  type    = string
  default = "LRS"
}

variable "argocd_namespace" {
  type    = string
  default = "argocd_matrix"
}

variable "eso_namespace" {
  type    = string
  default = "external-secrets-system"
}

variable "eso_identity_name" {
  type    = string
  default = "eso-identity"
}

variable "eso_federated_credential_name" {
  type    = string
  default = "eso-federated-credential"
}

variable "traefik_public_ip_name" {
  type    = string
  default = "traefik-public-ip"
}

variable "storage_containers" {
  description = "Blob containers used by the platform"

  type = map(string)

  default = {
    media  = "media"
    wal    = "wal"
    backup = "backup"
  }
}

##################
# DOCKERHUB creds
##################

variable "dockerhub_server" {
  type      = string
  sensitive = true
  default   = ""
}
variable "dockerhub_username" {
  type      = string
  sensitive = true
  default   = ""
}
variable "dockerhub_token" {
  type      = string
  sensitive = true
  default = ""
}

variable "kv_dockersrc_server_sname" {
  type      = string
  sensitive = true
  default   = "docker-registry-server"
}
variable "kv_dockersrc_username_sname" {
  type      = string
  sensitive = true
  default   = "docker-registry-username"
}
variable "kv_dockersrc_passwd_sname" {
  type      = string
  sensitive = true
  default = "docker-registry-password"
}


##################
# GitOps source
##################
variable "gitops_repository" {
  description = "Git repository containing Kubernetes manifests"
  type        = string
  default     = "https://github.com/vanlit/matrix-synapse-on-aks.git"
}

variable "gitops_revision" {
  description = "Git revision to sync"
  type        = string
  default     = "main"
}

############
# KV Secrets Names
############
variable "kv_redis_password_sname" {
    type      = string
    sensitive = false
    default = "redis-password"
}
variable "kv_matrix_postgres_username" {
    type      = string
    sensitive = false
    default = "matrix-postgres-username"
}
variable "kv_matrix_postgres_password" {
    type      = string
    sensitive = false
    default = "postgres-password"
}
variable "kv_synapse_registration_secret" {
    type      = string
    sensitive = false
    default = "synapse-registration-secret"
}
variable "kv_synapse_macaroon_secret" {
    type      = string
    sensitive = false
    default = "synapse-macaroon-secret"
}
variable "kv_synapse_form_secret" {
    type      = string
    sensitive = false
    default = "synapse-form-secret"
}
variable "kv_turn_static_auth_secret" {
    type      = string
    sensitive = false
    default = "turn-static-auth-secret"
}
variable "kv_authelia_jwt_secret" {
    type      = string
    sensitive = false
    default = "authelia-jwt-secret"
}
variable "kv_authelia_session_secret" {
    type      = string
    sensitive = false
    default = "authelia-session-secret"
}
variable "kv_authelia_storage_encryption_key" {
    type      = string
    sensitive = false
    default = "authelia-storage-encryption-key"
}