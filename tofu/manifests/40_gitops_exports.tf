############################################################
# GitOps export bundle (SAFE subset for ArgoCD consumption)
############################################################

locals {
  gitops_exports = {
    aks = {
      name        = azurerm_kubernetes_cluster.main.name
      oidc_issuer = azurerm_kubernetes_cluster.main.oidc_issuer_url
      fqdn        = azurerm_kubernetes_cluster.main.fqdn
    }

    keyvault = {
      name = azurerm_key_vault.main.name
      uri  = azurerm_key_vault.main.vault_uri
    }

    storage = {
      account       = azurerm_storage_account.main.name
      blob_endpoint = azurerm_storage_account.main.primary_blob_endpoint
      containers    = keys(azurerm_storage_container.platform)
    }

    traefik = {
      public_ip = azurerm_public_ip.traefik.ip_address
      name      = azurerm_public_ip.traefik.name
    }

    identities = {
      managed_identity_client_ids = {
        for k, v in azurerm_user_assigned_identity.managed :
        k => v.client_id
      }

      managed_identity_principal_ids = {
        for k, v in azurerm_user_assigned_identity.managed :
        k => v.principal_id
      }
    }

    environment = {
      resource_group = azurerm_resource_group.main.name
    }
  }
}

resource "local_file" "gitops_exports" {
  filename = pathexpand("~/matrix-tofu-outputs.json")
  content  = jsonencode(local.gitops_exports)
}