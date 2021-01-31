# use this in pipelines like this:
# terraform init -backend-config=backend.hcl
storage_account_name = "tfstate5678"
container_name       = "tfstate"
key                  = "shared-tfstate.tfstate"
resource_group_name  = "dev-tfstate-rg"