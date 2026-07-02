resource "local_file" "kubeconfig" {

  filename = pathexpand("~/.kube/matrix-prod")

  content = azurerm_kubernetes_cluster.main.kube_config_raw

  file_permission = "0600"
}

resource "null_resource" "wait_for_argocd" {

  depends_on = [
    helm_release.argocd,
    local_file.kubeconfig
  ]

  provisioner "local-exec" {

    command = <<EOT
KUBECONFIG=${local_file.kubeconfig.filename} \
kubectl rollout status deployment/argocd-server \
-n matrix-argocd \
--timeout=600s

KUBECONFIG=${local_file.kubeconfig.filename} \
kubectl rollout status deployment/argocd-repo-server \
-n matrix-argocd \
--timeout=600s

KUBECONFIG=${local_file.kubeconfig.filename} \
kubectl rollout status deployment/argocd-applicationset-controller \
-n matrix-argocd \
--timeout=600s
EOT
  }
}

resource "null_resource" "root_app" {

  depends_on = [
    null_resource.wait_for_argocd
  ]

  provisioner "local-exec" {

    command = <<EOT
KUBECONFIG=${local_file.kubeconfig.filename} \
kubectl apply \
-f ${path.module}/../apps/00-argocd/root-app.yaml
EOT
  }
}

resource "null_resource" "cleanup" {

  depends_on = [
    null_resource.root_app
  ]

  provisioner "local-exec" {

    when = destroy

    command = <<EOT
rm -f ~/.kube/matrix-prod
rm -f ~/.matrix-tofu-outputs.json
EOT
  }
}