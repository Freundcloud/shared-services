variable "tenant_id" {
  type        = string
  description = "Azure Tenant Id"
}

variable "environment" {
  type = string
  description = "eviroment descritption (sandbox, preprod, prod)"

}

variable "prefix" {}

variable "location" {
  description = "Location of the cluster."
}

variable "acr_name" {
  default = "aksdemosbxlzacr"
}

variable "tags" {
  type = map(string)

  default = {
    Approver = "X",
    ApplicationName = "x",
    BudgetAmount = "x",
    BusinessUnit = "x",
    CostCenter = "x",
    ServiceClass = "x",
    Location = "UKSOUTH"
  }
}

#AKS
variable "aks_name" {}
variable "aks_dns_prefix" {}
variable "kubernetes_version" {}
variable "aks_service_cidr" {}
variable "aks_dns_service_ip" {}
variable "aks_docker_bridge_cidr" {}
variable "aks_enable_rbac" {}
variable "public_ssh_key_path" {
  default     = ""
}

#SQL
variable "provision_database" {
    description = "Provision Database for the mircoservice. #Default set to false."

}

#Keyvault
variable "provision_key_vault" {
    description = "Provision Key Vault for the mircoservice. #Default set to false."

}

#Storage
variable "provision_blob_storage" {
    description = "Provision Blob storage for the mircoservice. #Default set to false."

}

#DNS
variable "domain" {
  type = string
  description = "domain name"
}

variable "address_space" {}
variable "kube_address_prefixes" {}
variable "ingress_address_prefixes" {}
variable "apps_address_prefixes" {}
variable "cluster_network" {
  default = false
}

variable "aad_group_name" {
  description = "Name of the Azure AD group for cluster-admin access"
  type        = string
  default     = "AKS-Admin"
}