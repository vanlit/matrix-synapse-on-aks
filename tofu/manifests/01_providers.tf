provider "azurerm" {
  features {}

  resource_provider_registrations = "extended"
}

provider "random" {}

provider "tls" {}