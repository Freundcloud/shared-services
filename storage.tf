resource "azurerm_storage_account" "blob_storage" {
  count = var.provision_blob_storage ? 1 : 0

  name                     = replace("${var.prefix}-${var.environment}-logs-blob","-","")
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags

  depends_on = [azurerm_resource_group.rg]
}

resource "azurerm_storage_container" "container" {
  count = var.provision_blob_storage ? 1 : 0

  name                  = "main"
  #resource_group_name   = azurerm_resource_group.rg.name
  storage_account_name  = azurerm_storage_account.blob_storage[0].name
  container_access_type = "private"
}
