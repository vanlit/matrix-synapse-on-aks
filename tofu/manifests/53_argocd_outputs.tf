###############################################################
# ArgoCD bootstrap outputs
###############################################################

resource "local_file" "argocd_admin_password" {

  filename = pathexpand("~/.matrix-argocd-admin")

  file_permission = "0600"

  content = <<EOT
ArgoCD has been installed.

Fetch the initial admin password with:

KUBECONFIG=${local_file.kubeconfig.filename} \
kubectl -n ${var.argocd_namespace} \
get secret argocd-initial-admin-secret \
-o jsonpath='{.data.password}' | base64 -d

Port-forward:

KUBECONFIG=${local_file.kubeconfig.filename} \
kubectl port-forward svc/argocd-server \
-n ${var.argocd_namespace} \
8080:443

Open:

https://localhost:8080

Username:

admin
EOT

  depends_on = [
    null_resource.root_app
  ]
}