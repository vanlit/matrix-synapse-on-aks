###############################################################
# Public IP for Traefik
###############################################################

resource "azurerm_public_ip" "traefik" {
  name                = local.traefik_public_ip_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  allocation_method = "Static"

  sku = "Standard"

  zones = [
    "1",
    "2",
    "3"
  ]

  tags = local.common_tags
}