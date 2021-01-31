resource "azurerm_key_vault" "kv" {
  count               = var.provision_key_vault ? 1 : 0
  name                = "${var.prefix}-${var.environment}-kv"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = var.tenant_id


  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
      "List",
      "Update",
      "Create",
      "Import",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "Decrypt",
      "Encrypt",
      "UnwrapKey",
      "WrapKey",
      "Verify",
      "Sign",
      "Purge"
    ]

    secret_permissions = [
      "Set",
      "Get",
      "Delete",
      "List",
      "Purge",
      "Restore",
      "Recover",
      "Backup"
    ]

    certificate_permissions = [
      "Get",
      "List",
      "Update",
      "Create",
      "Import",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "ManageContacts",
      "ManageIssuers",
      "GetIssuers",
      "ListIssuers",
      "SetIssuers",
      "DeleteIssuers",
      "Purge"
    ]
  }

  tags = var.tags
}

resource "azurerm_key_vault_access_policy" "access_policy" {
  count = var.provision_key_vault ? 1 : 0

  key_vault_id = azurerm_key_vault.kv[0].id

  tenant_id = var.tenant_id
  object_id = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id

  key_permissions = [
    "get",
    "list"
  ]

  secret_permissions = [
    "get",
    "list",
  ]

  certificate_permissions = [
    "get",
    "list"
  ]
}

resource "azurerm_key_vault_access_policy" "access_policy_2" {
  count = var.provision_key_vault ? 1 : 0

  key_vault_id = azurerm_key_vault.kv[0].id

  tenant_id = var.tenant_id
  object_id = "8f16078b-d50e-459d-8c15-5ea7413b98d2"

  key_permissions = [
    "Get",
    "List",
    "Update",
    "Create",
    "Import",
    "Delete",
    "Recover",
    "Backup",
    "Restore",
    "Decrypt",
    "Encrypt",
    "UnwrapKey",
    "WrapKey",
    "Verify",
    "Sign",
    "Purge"
  ]

  secret_permissions = [
    "Set",
    "Get",
    "Delete",
    "List",
    "Purge",
    "Restore",
    "Recover",
    "Backup"
  ]

  certificate_permissions = [
    "Get",
    "List",
    "Update",
    "Create",
    "Import",
    "Delete",
    "Recover",
    "Backup",
    "Restore",
    "ManageContacts",
    "ManageIssuers",
    "GetIssuers",
    "ListIssuers",
    "SetIssuers",
    "DeleteIssuers",
    "Purge"
  ]
}
