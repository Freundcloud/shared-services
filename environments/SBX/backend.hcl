# use this in pipelines like this:
# terraform init -backend-config=backend.hcl
storage_account_name = "tfstate5612"
container_name       = "tfstate"
key                  = "shared.tfstate"
resource_group_name  = "sbx-tfstate-rg"
subscription_id      = "089a59db-9910-4e4a-93ce-b557ad910bb2"
tenant_id            = "048aafcb-1b5a-4da8-802e-5a3f7f530521"