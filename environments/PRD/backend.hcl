# use this in pipelines like this:
# terraform init -backend-config=backend.hcl
storage_account_name = "tfstate3467"
container_name       = "tfstate"
key                  = "shared-terraform.tfstate"
resource_group_name  = "prd-tfstate-rg"