###############################################################
# Summary
###############################################################

output "deployment_summary" {
  description = "Summary of the deployed platform"

  value = {
    resource_group = azurerm_resource_group.main.name

    aks = {
      name = azurerm_kubernetes_cluster.main.name
      oidc = azurerm_kubernetes_cluster.main.oidc_issuer_url
    }

    keyvault = {
      name = azurerm_key_vault.main.name
      uri  = azurerm_key_vault.main.vault_uri
    }

    storage = {
      account    = azurerm_storage_account.main.name
      containers = keys(azurerm_storage_container.platform)
    }
  }
}

###############################################################
# Resource Group
###############################################################

output "resource_group_name" {
  description = "Azure Resource Group"

  value = azurerm_resource_group.main.name
}

###############################################################
# AKS
###############################################################

output "aks_name" {
  description = "AKS cluster name"

  value = azurerm_kubernetes_cluster.main.name
}

output "aks_fqdn" {
  description = "AKS API server FQDN"

  value = azurerm_kubernetes_cluster.main.fqdn
}

output "aks_node_resource_group" {
  description = "Managed node resource group"

  value = azurerm_kubernetes_cluster.main.node_resource_group
}

output "oidc_issuer_url" {
  description = "OIDC issuer URL for Workload Identity"

  value = azurerm_kubernetes_cluster.main.oidc_issuer_url
}

output "aks_kube_config_raw" {
  description = "Raw kubeconfig"

  value     = azurerm_kubernetes_cluster.main.kube_config_raw
  sensitive = true
}

###############################################################
# Key Vault
###############################################################

output "keyvault_name" {
  description = "Azure Key Vault name"

  value = azurerm_key_vault.main.name
}

output "keyvault_uri" {
  description = "Azure Key Vault URI"

  value = azurerm_key_vault.main.vault_uri
}

###############################################################
# Storage
###############################################################

output "storage_account_name" {
  description = "Azure Storage Account"

  value = azurerm_storage_account.main.name
}

output "storage_blob_endpoint" {
  description = "Blob service endpoint"

  value = azurerm_storage_account.main.primary_blob_endpoint
}

output "storage_containers" {
  description = "Blob containers"

  value = keys(azurerm_storage_container.platform)
}

###############################################################
# Networking
###############################################################

output "traefik_public_ip" {
  description = "Static public IP reserved for Traefik"

  value = azurerm_public_ip.traefik.ip_address
}

output "traefik_public_ip_name" {
  description = "Traefik Public IP resource"

  value = azurerm_public_ip.traefik.name
}

###############################################################
# User-Assigned Identities
###############################################################

output "managed_identity_client_ids" {

  value = {
    for k, v in azurerm_user_assigned_identity.managed :
    k => v.client_id
  }

}

output "managed_identity_principal_ids" {

  value = {
    for k, v in azurerm_user_assigned_identity.managed :
    k => v.principal_id
  }

}

output "managed_identity_ids" {

  value = {
    for k, v in azurerm_user_assigned_identity.managed :
    k => v.id
  }

}