resource "azurerm_kubernetes_cluster" "main" {
  name                = local.aks_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  dns_prefix = local.aks_name

  # kubernetes_version = null # by default, lets Azure choose latest supported patch

  # ------------------------------------------------------------
  # Node pool (system)
  # ------------------------------------------------------------
  default_node_pool {
    name       = local.aks_node_pool_name
    node_count = var.aks_node_count_min
    vm_size    = var.aks_node_vm_size

    type       = "VirtualMachineScaleSets"
    mode       = "System"

    enable_auto_scaling = true

    min_count = var.aks_node_count_min
    max_count = var.aks_node_count_max
  }

  # ------------------------------------------------------------
  # Identity (managed identity)
  # ------------------------------------------------------------
  identity {
    type = "SystemAssigned"
  }

  # ------------------------------------------------------------
  # Networking (matches your CLI config)
  # ------------------------------------------------------------
  network_profile {
    network_plugin    = "azure"
    network_plugin_mode = "overlay"
    load_balancer_sku = "standard"
  }

  # ------------------------------------------------------------
  # Workload identity + OIDC issuer (CRITICAL for ESO)
  # ------------------------------------------------------------
  oidc_issuer_enabled       = true
  workload_identity_enabled  = true

  # ------------------------------------------------------------
  # SSH access
  # ------------------------------------------------------------
  linux_profile {
    admin_username = "azureuser"

    ssh_key {
      key_data = tls_private_key.aks_ssh.public_key_openssh
    }
  }

  # ------------------------------------------------------------
  # System defaults
  # ------------------------------------------------------------
  tags = local.common_tags

  image_cleaner_enabled        = true
  image_cleaner_interval_hours = 48
  automatic_upgrade_channel = "patch"
}
