terraform {
  backend "azurerm" {
    storage_account_name = "tfstatefroun"
    container_name       = "database"
    key                  = "database-terraform.tfstate"
    access_key           = "qtv1HIQIpoth6sCBNdGKy4aqhSqhewEIxdsSNvDA2OoqdV3A+qPtYN/ovMCDJQxWgdQby3Q9iq1qNdeSn+RZiw=="
  }
}
provider "azurerm" {
  version = "~> 2.15"
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

resource "azurerm_resource_group" "database" {
  name     = "${var.environment}-${var.microservice}-rg"
  location = var.location
}

resource "random_string" "unique" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_storage_account" "database" {
  name                     = format("%s%ssa", lower(replace(var.microservice, "/[[:^alnum:]]/", "")), random_string.unique.result)
  resource_group_name      = azurerm_resource_group.database.name
  location                 = azurerm_resource_group.database.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "random_password" "password" {
  count = var.provision_database ? 1 : 0

  length           = 16
  special          = true
  override_special = "_%@"
}

data "azurerm_key_vault" "kv" {
  name                = "${var.environment}-${var.facing}-kv"
  resource_group_name = "${var.environment}-${var.facing}-microservices-rg"
}

resource "azurerm_key_vault_secret" "db_password" {
  count = var.provision_database ? 1 : 0

  name         = "${var.environment}-${var.microservice}-db-password"
  value        = random_password.password[0].result
  key_vault_id = data.azurerm_key_vault.kv.id

  tags = var.tags
}

resource "azurerm_sql_server" "sqlserver" {
  count = var.provision_database ? 1 : 0

  name                         = "${var.environment}-${var.microservice}-db-server"
  location                     = azurerm_resource_group.database.location
  resource_group_name          = azurerm_resource_group.database.name
  version                      = "12.0"
  administrator_login          = "${var.environment}-${var.microservice}-db-admin"
  administrator_login_password = azurerm_key_vault_secret.db_password[0].value

  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.database.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.database.primary_access_key
    storage_account_access_key_is_secondary = true
    retention_in_days                       = 6
  }

  tags = var.tags

}

resource "azurerm_sql_database" "db" {
  count = var.provision_database ? 1 : 0

  name                = "${var.environment}-${var.microservice}-db"
  location            = azurerm_resource_group.database.location
  resource_group_name = azurerm_resource_group.database.name
  server_name         = azurerm_sql_server.sqlserver[0].name
  edition             = "Basic"

  tags = var.tags

}

resource "azurerm_sql_firewall_rule" "firewall" {
  count = var.provision_firewall_rules ? 1 : 0

  name                = "AllowAzureServices"
  resource_group_name = azurerm_resource_group.database.name
  server_name         = azurerm_sql_server.sqlserver[0].name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

data "azurerm_virtual_network" "test" {
  name                = "${var.environment}-${var.facing}-aks-vnet"
  resource_group_name = "${var.environment}-${var.facing}-microservices-rg"
}

data "azurerm_subnet" "kubesubnet" {
  name                 = "kubesubnet"
  virtual_network_name = "${var.environment}-${var.facing}-aks-vnet"
  resource_group_name  = "${var.environment}-${var.facing}-microservices-rg"
}

resource "azurerm_sql_virtual_network_rule" "sqlvnetrule" {
  name                = "sql-vnet-rule"
  resource_group_name = azurerm_resource_group.database.name
  server_name         = azurerm_sql_server.sqlserver[0].name
  subnet_id           = data.azurerm_subnet.kubesubnet.id
}

resource "azurerm_user_assigned_identity" "Microservice_Identity" {
  name                = "${var.environment}-${var.microservice}-db-identity"
  location            = azurerm_resource_group.database.location
  resource_group_name = azurerm_resource_group.database.name

  tags = var.tags
}

resource "azurerm_role_assignment" "db_contributor" {
  count = var.provision_identity ? 1 : 0

  scope                = azurerm_sql_server.sqlserver[0].id
  principal_id         = azurerm_user_assigned_identity.Microservice_Identity.principal_id
  role_definition_name = "Contributor"
}