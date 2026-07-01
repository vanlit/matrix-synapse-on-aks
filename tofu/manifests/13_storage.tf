resource "azurerm_storage_account" "main" {
  name                = local.storage_account_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_replication_type

  account_kind = "StorageV2"

  #
  # Recommended defaults
  #
  access_tier = "Hot"

  https_traffic_only_enabled = true

  min_tls_version = "TLS1_2"

  allow_nested_items_to_be_public = false

  shared_access_key_enabled = true

  tags = local.common_tags
}

resource "azurerm_storage_container" "platform" {
  for_each = var.storage_containers

  name                  = each.value
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = "private"
}