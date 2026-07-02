############################################################
# Platform-generated secrets
############################################################

locals {
  generated_secrets = {

    redis-password = {
      length  = 64
      special = true
    }

    matrix-postgres-password = {
      length  = 64
      special = true
    }

    synapse-registration-secret = {
      length  = 64
      special = true
    }

    synapse-macaroon-secret = {
      length  = 64
      special = true
    }

    synapse-form-secret = {
      length  = 64
      special = true
    }

    turn-static-auth-secret = {
      length  = 64
      special = true
    }

    authelia-jwt-secret = {
      length  = 64
      special = true
    }

    authelia-session-secret = {
      length  = 64
      special = true
    }

    authelia-storage-encryption-key = {
      length  = 64
      special = true
    }
  }
}

############################################################
# Random passwords
############################################################
resource "random_password" "generated" {
  for_each = local.generated_secrets

  length           = each.value.length
  special          = each.value.special

  override_special = "!@#$%^&*()-=_+[]{};:"
}

############################################################
# Put random password to Key Vault secrets
############################################################
resource "azurerm_key_vault_secret" "generated" {
  for_each = random_password.generated

  name         = each.key
  value        = each.value.result
  key_vault_id = azurerm_key_vault.main.id
}

############################################################
# Static platform secrets
############################################################
resource "azurerm_key_vault_secret" "matrix_postgres_username" {
  name         = "matrix-postgres-username"
  value        = "matrix"

  key_vault_id = azurerm_key_vault.main.id
}

############################################################
# DockerHub credentials
############################################################

resource "azurerm_key_vault_secret" "dockerhub_server" {

  count = var.dockerhub_username != "" ? 1 : 0

  name         = "dockerhub-server"
  value        = "https://index.docker.io/v2/"
  key_vault_id = azurerm_key_vault.main.id

}

resource "azurerm_key_vault_secret" "dockerhub_username" {

  count = var.dockerhub_username != "" ? 1 : 0

  name         = "dockerhub-username"
  value        = var.dockerhub_username

  key_vault_id = azurerm_key_vault.main.id

}

resource "azurerm_key_vault_secret" "dockerhub_token" {

  count = var.dockerhub_token != "" ? 1 : 0

  name         = "dockerhub-password"
  value        = var.dockerhub_token

  key_vault_id = azurerm_key_vault.main.id

}