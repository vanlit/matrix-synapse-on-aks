############################################################
# External Secrets Operator Azure integration
#
# OpenTofu owns:
#   - Federated Identity Credential
#   - Azure RBAC
#
# ArgoCD owns:
#   - ESO Helm chart
#   - ServiceAccount
#   - ClusterSecretStore
############################################################

#
# Allow the ESO managed identity to authenticate
# as the Kubernetes ServiceAccount.
#
resource "azurerm_federated_identity_credential" "eso" {
  name = "${local.name_prefix}-eso"
  resource_group_name = azurerm_resource_group.main.name
  parent_id = azurerm_user_assigned_identity.managed["eso"].id
  issuer = azurerm_kubernetes_cluster.main.oidc_issuer_url
  audience = [
    "api://AzureADTokenExchange"
  ]
  subject = "system:serviceaccount:eso:external-secrets"
}

#
# Allow ESO to read secrets from Key Vault.
#
resource "azurerm_role_assignment" "eso_keyvault_reader" {
  scope = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets User"
  principal_id = azurerm_user_assigned_identity.managed["eso"].principal_id
}
