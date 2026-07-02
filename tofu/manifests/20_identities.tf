locals {

  managed_identities = {
    eso = {
      name = "${local.name_prefix}-eso"
    }

    cnpg = {
      name = "${local.name_prefix}-cnpg"
    }

    traefik = {
      name = "${local.name_prefix}-traefik"
    }
  }

}

resource "azurerm_user_assigned_identity" "managed" {

  for_each = local.managed_identities

  name                = each.value.name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = local.common_tags
}