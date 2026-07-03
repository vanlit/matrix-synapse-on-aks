#!/usr/bin/env bash
set -euo pipefail

. ./cfg.sh

ARGO_HELM_REPO="https://argoproj.github.io/argo-helm"

echo "========================================"
echo "ArgoCD Bootstrap"
echo "========================================"
echo

echo "### 1 - Creating namespace: ${TF_VAR_argocd_namespace}"
kubectl create namespace "${TF_VAR_argocd_namespace}" --dry-run=client -o yaml | kubectl apply -f -

echo "### 2 - Adding Argo Helm repo..."
helm repo add argo "${ARGO_HELM_REPO}" >/dev/null 2>&1 || true
helm repo update >/dev/null

echo "### 3 - Installing ArgoCD via Helm..."
helm upgrade --install argocd argo/argo-cd \
  --namespace "${TF_VAR_argocd_namespace}" \
  --create-namespace \
  --set server.service.type=ClusterIP

echo "### 4 - Waiting for ArgoCD deployments... (timeout after 300s)"
kubectl rollout status deploy/argocd-server -n "${TF_VAR_argocd_namespace}" --timeout=300s
kubectl rollout status deploy/argocd-repo-server -n "${TF_VAR_argocd_namespace}" --timeout=300s
kubectl rollout status deploy/argocd-applicationset-controller -n "${TF_VAR_argocd_namespace}" --timeout=300s
echo "Success, ArgoCD pods are Ready"

echo
echo "### 5 - Fetching initial admin password..."
ARGO_PWD=$(kubectl -n "${TF_VAR_argocd_namespace}" get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d)

echo
echo "========================================"
echo "ArgoCD READY"
echo "========================================"
echo
echo "Namespace: ${TF_VAR_argocd_namespace}"
echo "Username:   admin"
echo "Password:   ${ARGO_PWD}"
echo
echo "Access (temporary):"
echo "  kubectl port-forward svc/argocd-server -n ${TF_VAR_argocd_namespace} 8080:443"
echo "  https://localhost:8080"
echo
