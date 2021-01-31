# Azure Subscription Id
variable "azure_subscription_id" {
  type        = string
  description = "Azure Subscription Id"
  default     = "089a59db-9910-4e4a-93ce-b557ad910bb2"
}
# Azure Client Id/appId
variable "azure_client_id" {
  type        = string
  description = "Azure Client Id/appId"
  default = "39f7ea26-05f6-409b-a615-bf8592bbdb14"
}
# Azure Client Id/appId
variable "azure_client_secret" {
  type        = string
  description = "Azure Client Id/appId"
  default = "7W.BYCicWiQe8Acn6ol..yKnKzoQ934LtJ"
}
# Azure Tenant Id
variable "azure_tenant_id" {
  type        = string
  description = "Azure Tenant Id"
  default = "048aafcb-1b5a-4da8-802e-5a3f7f530521"
}

variable "environment" {
  default = "sbx"
}

variable "microservice" {
  default = "common"
}

variable "location" {
  description = "Azure location where resources should be deployed."
  default = "uksouth"
}

variable "network_rules" {
  description = "Network rules restricing access to the storage account."
  type = object({
    ip_rules   = list(string),
    subnet_ids = list(string),
    bypass     = list(string)
  })
  default = null
}

variable "containers" {
  description = "List of containers to create and their access levels."
  type = list(object({
    name        = string,
    access_type = string
  }))
  default = []
}

variable "tags" {
  type = map(string)

  default = {
    source = "terraform"
  }
}

variable "enable_advanced_threat_protection" {
  description = "Boolean flag which controls if advanced threat protection is enabled."
  type        = bool
  default     = false
}
