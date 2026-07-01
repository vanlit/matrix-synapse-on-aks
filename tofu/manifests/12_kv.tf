resource "azurerm_key_vault" "main" {
  name                = local.keyvault_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tenant_id = data.azurerm_client_config.current.tenant_id
  sku_name  = var.keyvault_sku

  #
  # We use Azure RBAC instead of legacy access policies.
  #
  enable_rbac_authorization = true

  #
  # Soft delete is mandatory on modern Key Vaults.
  #
  soft_delete_retention_days = 90

  #
  # Prevent immediate purge.
  #
  purge_protection_enabled = true

  #
  # Public access is acceptable for now.
  # Later we may switch to Private Endpoints.
  #
  public_network_access_enabled = true

  tags = local.common_tags
}