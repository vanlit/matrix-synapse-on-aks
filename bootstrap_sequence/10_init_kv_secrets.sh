#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "$0")/../cfg.sh"

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

create_secret $KV_REDIS_PASSWORD                  "$(rand64)"
create_secret $KV_POSTGRES_PASSWORD               "$(rand64)"
create_secret $KV_SYNAPSE_REGISTRATION_SECRET     "$(rand64)"
create_secret $KV_SYNAPSE_MACAROON_SECRET         "$(rand64)"
create_secret $KV_SYNAPSE_FORM_SECRET             "$(rand64)"
create_secret $KV_TURN_STATIC_AUTH_SECRET         "$(rand64)"
create_secret $KV_AUTHELIA_JWT_SECRET             "$(rand64)"
create_secret $KV_AUTHELIA_SESSION_SECRET         "$(rand64)"
create_secret $KV_AUTHELIA_STORAGE_ENCRYPTION_KEY "$(rand64)"

echo
echo "Key Vault successfully seeded."