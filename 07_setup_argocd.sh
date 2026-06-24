#!/usr/bin/env bash
set -euo pipefail

. ./cfg.sh

ARGO_HELM_REPO="https://argoproj.github.io/argo-helm"

echo "========================================"
echo "ArgoCD Bootstrap"
echo "========================================"
echo

echo "1 - Creating namespace: ${ARGO_NS}"
kubectl create namespace "${ARGO_NS}" --dry-run=client -o yaml | kubectl apply -f -

echo "2 - Adding Argo Helm repo..."
helm repo add argo "${ARGO_HELM_REPO}" >/dev/null 2>&1 || true
helm repo update >/dev/null

echo "3 - Installing ArgoCD via Helm..."
helm upgrade --install argocd argo/argo-cd \
  --namespace "${ARGO_NS}" \
  --create-namespace \
  --set server.service.type=ClusterIP

echo "4 - Waiting for ArgoCD deployments... (timeout after 300s)"
kubectl wait pod \
  --all \
  -n "${ARGO_NS}" \
  --for=condition=Ready \
  --timeout=180s
echo "Success, ArgoCD pods are Ready"

echo
echo "5 - Fetching initial admin password..."
ARGO_PWD=$(kubectl -n "${ARGO_NS}" get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d)

echo
echo "========================================"
echo "ArgoCD READY"
echo "========================================"
echo
echo "Namespace: ${ARGO_NS}"
echo "Username:   admin"
echo "Password:   ${ARGO_PWD}"
echo
echo "Access (temporary):"
echo "  kubectl port-forward svc/argocd-server -n ${ARGO_NS} 8080:443"
echo "  https://localhost:8080"
echo