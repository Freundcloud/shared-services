resource "azurerm_kubernetes_cluster" "aks" {
  name               = "${var.prefix}-${var.environment}-aks"
  location           = var.location
  dns_prefix         = var.aks_dns_prefix
  kubernetes_version = var.kubernetes_version

  resource_group_name = azurerm_resource_group.rg.name

  addon_profile {
    http_application_routing {
      enabled = false
    }

    azure_policy {
      enabled = true
    }

    kube_dashboard {
      enabled = false
    }

    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = data.azurerm_log_analytics_workspace.logs.id
    }
  }

  default_node_pool {
    name                = "agentpool"
    enable_auto_scaling = false
    node_count          = 3
    vm_size             = "Standard_B2s"
    os_disk_size_gb     = 100
    vnet_subnet_id      = azurerm_subnet.kubesubnet.id
    availability_zones  = [1, 2, 3]
  }

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control {
    enabled = true

    azure_active_directory {
      managed = true
      admin_group_object_ids = [
        data.azuread_group.aks.id
      ]
    }
  }

  network_profile {
    network_plugin     = "azure"
    network_policy     = "azure"
    dns_service_ip     = var.aks_dns_service_ip
    docker_bridge_cidr = var.aks_docker_bridge_cidr
    service_cidr       = var.aks_service_cidr
    outbound_type      = "loadBalancer"
  }

  depends_on = [
    azurerm_virtual_network.kubenet
  ]
  tags = var.tags
}

resource "azurerm_role_assignment" "aks" {
  scope                = azurerm_kubernetes_cluster.aks.id
  role_definition_name = "Monitoring Metrics Publisher"
  principal_id         = azurerm_kubernetes_cluster.aks.addon_profile[0].oms_agent[0].oms_agent_identity[0].object_id
}

resource "azurerm_role_assignment" "aks_subnet" {
  scope                = azurerm_subnet.kubesubnet.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}

resource "azurerm_role_assignment" "aks_acr" {
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}