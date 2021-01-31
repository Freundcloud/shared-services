output "database_log_storage" {
    value = "azurerm_storage_account.database.name"
}

output "sqlserver" {
    value = "azurerm_sql_server.sqlserver.name"
}

output "database_name" {
    value = "azurerm_sql_database.db.name"
}

output "Microservice_Identity" {
    value = "azurerm_user_assigned_identity.Microservice_Identity.name"
}