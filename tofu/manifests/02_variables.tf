variable "project" {
  description = "Project name used as global prefix for all resources"
  type        = string
  default     = "matrix"
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
  default     = "prod"
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
    managed_by = "argocd"
    project    = "matrix"
  }
}

variable "aks_node_count_min" {
  type        = number
  default     = 1
}
variable "aks_node_count_max" {
  type        = number
  default     = 1
}

variable "aks_node_vm_size" {
  type        = string
  default     = "Standard_D4s_v5"
}

variable "keyvault_sku" {
  type    = string
  default = "standard"
}

variable "storage_account_tier" {
  type    = string
  default = "Standard"
}

variable "storage_replication_type" {
  type    = string
  default = "LRS"
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
    media   = "media"
    wal     = "wal"
    backup  = "backup"
  }
}