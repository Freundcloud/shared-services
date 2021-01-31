resource "azurerm_network_security_group" "ingress_nsg" {
  name                = "${var.prefix}-${var.environment}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "all"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

resource "azurerm_subnet_network_security_group_association" "appg_nsg_appgwsubnet" {
  subnet_id                 = azurerm_subnet.ingresssubnet.id
  network_security_group_id = azurerm_network_security_group.ingress_nsg.id
}