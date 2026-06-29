#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(git rev-parse --show-toplevel)"
rm -rf "$ROOT_DIR/infra/00-argocd/*.yaml"
cp "$ROOT_DIR"/argocd/*.yaml "$ROOT_DIR/infra/00-argocd/"
