data "azurerm_subscription" "current" {}
data "azurerm_client_config" "current" {}

data "azurerm_log_analytics_workspace" "logs" {
    name = "${var.prefix}-${var.environment}-lz-logs"
    resource_group_name = "${var.prefix}-${var.environment}-core-rg"
}

data "azurerm_key_vault" "core_keyvault" {
  name                = "${var.prefix}-${var.environment}-lz-kv"
  resource_group_name = "${var.prefix}-${var.environment}-core-rg"
}

data "azurerm_container_registry" "acr" {
  name                =  var.acr_name
  resource_group_name = "${var.prefix}-${var.environment}-core-rg"
}

data "azuread_group" "aks" {
  display_name = var.aad_group_name
}