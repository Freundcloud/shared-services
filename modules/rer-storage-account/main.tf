terraform {
  backend "azurerm" {
    storage_account_name = "tfstatefroun"
    container_name       = "storage"
    key                  = "storage-terraform.tfstate"
    access_key           = "qtv1HIQIpoth6sCBNdGKy4aqhSqhewEIxdsSNvDA2OoqdV3A+qPtYN/ovMCDJQxWgdQby3Q9iq1qNdeSn+RZiw=="
  }
}
provider "azurerm" {
  # subscription_id = "var.azure_subscription_id"
  # client_id       = "var.azure_client_id"
  # client_secret   = "var.azure_client_secret"
  # tenant_id       = "var.azure_tenant_id"
  version         = "~> 2.15"
  features {}
}
provider "azuread" {
  version = "= 0.9"
}
provider "null" {
  version = "~>2.1"
}
provider "tls" {
  version = "~>2.1"
}

resource "azurerm_resource_group" "storage" {
  name     = "${var.environment}-${var.microservice}-rg"
  location = var.location
}

resource "random_string" "unique" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_storage_account" "storage" {
  name                     = format("%s%ssa", lower(replace(var.microservice, "/[[:^alnum:]]/", "")), random_string.unique.result)
  resource_group_name      = azurerm_resource_group.storage.name

  location                 = azurerm_resource_group.storage.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "GRS"

  dynamic "network_rules" {
    for_each = var.network_rules != null ? ["true"] : []
    content {
      default_action             = "Deny"
      ip_rules                   = var.network_rules.ip_rules
      virtual_network_subnet_ids = var.network_rules.subnet_ids
      bypass                     = var.network_rules.bypass
    }
  }

  tags = var.tags
}

resource "azurerm_advanced_threat_protection" "threat_protection" {
  target_resource_id = azurerm_storage_account.storage.id
  enabled            = var.enable_advanced_threat_protection
}

resource "azurerm_storage_container" "storage" {
  count                 = length(var.containers)
  name                  = var.containers[count.index].name
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = var.containers[count.index].access_type
}

resource "azurerm_user_assigned_identity" "Microservice_Identity" {
  name                = "${var.environment}-${var.microservice}-identity"
  location            = azurerm_resource_group.storage.location
  resource_group_name = azurerm_resource_group.storage.name

  tags = var.tags
}

resource "azurerm_role_assignment" "container_contributor" {
  
  scope                = azurerm_storage_account.storage.id
  principal_id         = azurerm_user_assigned_identity.Microservice_Identity.principal_id
  role_definition_name = "Storage Blob Data Contributor"
}