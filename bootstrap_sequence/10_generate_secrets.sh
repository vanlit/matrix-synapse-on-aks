#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "$0")/../env.sh"

echo "Seeding Azure Key Vault: ${KV_NAME}"

create_secret() {
    local name="$1"
    local value="$2"

    if az keyvault secret show \
        --vault-name "${KV_NAME}" \
        --name "${name}" >/dev/null 2>&1
    then
        echo "✓ ${name} already exists"
    else
        az keyvault secret set \
            --vault-name "${KV_NAME}" \
            --name "${name}" \
            --value "${value}" >/dev/null

        echo "+ Created ${name}"
    fi
}

rand64() {
    openssl rand -base64 64 | tr -d '\n'
}

echo
echo "Generating platform secrets..."

create_secret redis-password                  "$(rand64)"

create_secret postgres-password               "$(rand64)"

create_secret synapse-registration-secret     "$(rand64)"
create_secret synapse-macaroon-secret         "$(rand64)"
create_secret synapse-form-secret             "$(rand64)"

create_secret turn-static-auth-secret         "$(rand64)"

create_secret authelia-jwt-secret             "$(rand64)"
create_secret authelia-session-secret         "$(rand64)"
create_secret authelia-storage-encryption-key "$(rand64)"

echo
echo "Key Vault successfully seeded."