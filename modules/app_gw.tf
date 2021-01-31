locals {
    backend_address_pool_name      = "${azurerm_virtual_network.test.name}-beap"
    frontend_port_name             = "${azurerm_virtual_network.test.name}-feport"
    frontend_ip_configuration_name = "${azurerm_virtual_network.test.name}-feip"
    http_setting_name              = "${azurerm_virtual_network.test.name}-be-htst"
    listener_name                  = "${azurerm_virtual_network.test.name}-httplstn"
    request_routing_rule_name      = "${azurerm_virtual_network.test.name}-rqrt"
    app_gateway_subnet_name        = "${var.prefix}-${var.environment}-${var.facing}-sub-apgw"
}

resource "azurerm_application_gateway" "network" {
  name                = "${var.prefix}-${var.environment}-${var.facing}-apgw"
  resource_group_name = azurerm_resource_group.rg.name  #azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location       

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = azurerm_subnet.appgwsubnet.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_port {
    name = "httpsPort"
    port = 443
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.test.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }

  tags = var.tags

  depends_on = [
    azurerm_virtual_network.test,
    azurerm_public_ip.test
  ]
}