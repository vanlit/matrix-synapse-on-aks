locals {
  # ------------------------------------------------------------
  # Core naming base
  # ------------------------------------------------------------
  name_prefix = "${var.project}-${var.environment}"

  # ------------------------------------------------------------
  # Resource Group
  # ------------------------------------------------------------
  resource_group_name = "${local.name_prefix}-rg"

  # ------------------------------------------------------------
  # AKS
  # ------------------------------------------------------------
  aks_name = "${local.name_prefix}-aks"

  aks_identity_name = "${local.name_prefix}-aks-mi"

  # Kubernetes / OIDC derived values will come later
  # (we'll wire them once AKS is declared in 11_aks.tf)

  # ------------------------------------------------------------
  # Key Vault
  # ------------------------------------------------------------
  keyvault_name = replace(
    "${local.name_prefix}-kv",
    "-",
    ""
  )

  # Key Vault must be globally unique and match Azure rules:
  # - only alphanumeric and hyphens removed here for safety
  # - we will enforce uniqueness via suffix later if needed

  # ------------------------------------------------------------
  # Storage Account
  # ------------------------------------------------------------
  storage_account_name = lower(
    replace("${local.name_prefix}st", "-", "")
  )

  # ------------------------------------------------------------
  # Public IP (Traefik)
  # ------------------------------------------------------------
  traefik_public_ip_name = "${local.name_prefix}-traefik-ip"

  # ------------------------------------------------------------
  # Azure Key Vault access / RBAC
  # ------------------------------------------------------------
  kv_secrets_user_role = "Key Vault Secrets User"

  # ------------------------------------------------------------
  # ESO (External Secrets Operator)
  # ------------------------------------------------------------
  eso_namespace = var.eso_namespace

  eso_identity_name = var.eso_identity_name

  eso_federated_credential_name = var.eso_federated_credential_name

  eso_sa_name = "external-secrets"

  # ------------------------------------------------------------
  # Kubernetes cluster defaults (future use)
  # ------------------------------------------------------------
  aks_node_pool_name = "system"

  # ------------------------------------------------------------
  # Tags (centralized merge)
  # ------------------------------------------------------------
  common_tags = merge(
    var.tags,
    {
      environment = var.environment
      region      = var.location
      prefix      = local.name_prefix
    }
  )
}