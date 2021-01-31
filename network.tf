resource "azurerm_virtual_network" "kubenet" {
  name                = "${var.prefix}-${var.environment}-aks-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [var.address_space]

  tags = var.tags

  depends_on = [azurerm_resource_group.rg]
}

resource "azurerm_subnet" "kubesubnet" {
  name                 = "${var.prefix}-${var.environment}-sub-aks"
  virtual_network_name = azurerm_virtual_network.kubenet.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = [var.kube_address_prefixes]

  service_endpoints = [
    "Microsoft.Storage",
    "Microsoft.KeyVault",
    "Microsoft.Sql",
    "Microsoft.ContainerRegistry"
  ]
  depends_on = [azurerm_virtual_network.kubenet]
}

resource "azurerm_subnet" "ingresssubnet" {
  name                 = "${var.prefix}-${var.environment}-sub-ing"
  virtual_network_name = azurerm_virtual_network.kubenet.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = [var.ingress_address_prefixes]
  depends_on           = [azurerm_virtual_network.kubenet]
}

resource "azurerm_subnet" "appsubnet" {
  name                 = "${var.prefix}-${var.environment}-sub-apps"
  virtual_network_name = azurerm_virtual_network.kubenet.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = [var.apps_address_prefixes]
  depends_on           = [azurerm_virtual_network.kubenet]
}
