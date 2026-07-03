############################################################
# Give access to myself
############################################################

resource "azurerm_role_assignment" "current_user_kv_secrets_officer" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

############################################################
# Platform-generated secrets
############################################################

locals {
  generated_secrets = {

    redis-password = {
      sname   = var.kv_redis_password_sname
      length  = 64
      special = true
    }

    matrix-postgres-password = {
      sname   = var.kv_matrix_postgres_password
      length  = 64
      special = true
    }

    synapse-registration-secret = {
      sname   = var.kv_synapse_registration_secret
      length  = 64
      special = true
    }

    synapse-macaroon-secret = {
      sname   = var.kv_synapse_macaroon_secret
      length  = 64
      special = true
    }

    synapse-form-secret = {
      sname   = var.kv_synapse_form_secret
      length  = 64
      special = true
    }

    turn-static-auth-secret = {
      sname = var.kv_turn_static_auth_secret
      length  = 64
      special = true
    }

    authelia-jwt-secret = {
      sname   = var.kv_authelia_jwt_secret
      length  = 64
      special = true
    }

    authelia-session-secret = {
      sname   = var.kv_authelia_session_secret
      length  = 64
      special = true
    }

    authelia-storage-encryption-key = {
      sname   = var.kv_authelia_storage_encryption_key
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

  depends_on = [
    azurerm_role_assignment.current_user_kv_secrets_officer
  ]
}

############################################################
# Static platform secrets
############################################################
resource "azurerm_key_vault_secret" "matrix_postgres_username" {
  name         = var.kv_matrix_postgres_username
  value        = "matrix"

  key_vault_id = azurerm_key_vault.main.id

  depends_on = [
    azurerm_role_assignment.current_user_kv_secrets_officer
  ]
}

############################################################
# DockerHub credentials
############################################################

resource "azurerm_key_vault_secret" "docker-registry-server" {

  count = var.dockerhub_username != "" ? 1 : 0

  name         = var.kv_dockersrc_server_sname
  value        = "https://index.docker.io/v2/"
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [
    azurerm_role_assignment.current_user_kv_secrets_officer
  ]
}

resource "azurerm_key_vault_secret" "docker-registry-username" {

  count = var.dockerhub_username != "" ? 1 : 0

  name         = var.kv_dockersrc_username_sname
  value        = var.dockerhub_username

  key_vault_id = azurerm_key_vault.main.id

  depends_on = [
    azurerm_role_assignment.current_user_kv_secrets_officer
  ]
}

resource "azurerm_key_vault_secret" "docker-registry-password" {

  count = var.dockerhub_token != "" ? 1 : 0

  name         = var.kv_dockersrc_passwd_sname
  value        = var.dockerhub_token

  key_vault_id = azurerm_key_vault.main.id

  depends_on = [
    azurerm_role_assignment.current_user_kv_secrets_officer
  ]
}