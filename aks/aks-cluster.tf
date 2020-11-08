resource "azurerm_kubernetes_cluster" "aks" {
  # ResourcegroupName of the Nodepool
  node_resource_group = "${azurerm_resource_group.primary.name}-we-aks"
  dns_prefix          = local.aks_cluster_name
  location            = azurerm_resource_group.primary.location
  name                = local.aks_cluster_name
  resource_group_name = azurerm_resource_group.primary.name
  kubernetes_version  = data.azurerm_kubernetes_service_versions.current.latest_version

  default_node_pool {
    name       = "system"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
    # Autoupgrade
    orchestrator_version = data.azurerm_kubernetes_service_versions.current.latest_version
    # Add to availability zones
    availability_zones   = [1, 2, 3]
    # Enabled autoscale
    enable_auto_scaling  = true
    max_count            = 4
    min_count            = 1
    # High IOPS
    os_disk_size_gb      = 1024
  }

  identity { type = "SystemAssigned" }

  tags = {
    Environment = "Engineering"
  }

  addon_profile {
    azure_policy { enabled = true }
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = azurerm_log_analytics_workspace.insights.id
    }
  }

  role_based_access_control {
    enabled = true
    azure_active_directory {
      managed                = true
      admin_group_object_ids = [azuread_group.aks_administrators.object_id]
    }
  }
}