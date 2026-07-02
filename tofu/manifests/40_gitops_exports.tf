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
      account    = azurerm_storage_account.main.name
      blob_endpoint = azurerm_storage_account.main.primary_blob_endpoint

      containers = [
        for c in azurerm_storage_container.platform : c.name
      ]
    }

    traefik = {
      public_ip = azurerm_public_ip.traefik.ip_address
      name      = azurerm_public_ip.traefik.name
    }

    identities = {
      managed_identity_client_ids = local.managed_identity_client_ids
      managed_identity_principal_ids = local.managed_identity_principal_ids
    }

    environment = {
      resource_group = azurerm_resource_group.main.name
    }
  }
}

############################################################
# Materialize to local filesystem
############################################################

resource "local_file" "gitops_exports" {
  filename = pathexpand("~/matrix-tofu-outputs.json")

  content = jsonencode(local.gitops_exports)
}