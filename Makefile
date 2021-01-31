.ONESHELL:
SHELL=/bin/bash

.PHONY: 
sbx-int:
	rm -rf .terraform
	source ./environments/sbx/.env-int.sh
	terraform init -backend-config=./environments/sbx/backend-int.hcl
	terraform workspace select int
	terraform plan -var-file=./environments/sbx/int.tfvars -out=./plan/plan-sbx-int
	terraform graph -type=plan | dot -Tsvg > ./images/sbx-int-plan.svg
	terraform apply "./plan/plan-sbx-int"
	az aks get-credentials --name ofg-sbx-i-aks --resource-group  ofg-sbx-i-aks-rg --admin --overwrite-existing
	az aks update --name ofg-sbx-i-aks --resource-group  ofg-sbx-i-aks-rg --attach-acr "/subscriptions/1dda66b2-2d18-40b8-98c4-6fb5471bdbea/resourceGroups/common-rer-rg/providers/Microsoft.ContainerRegistry/registries/commonrercr"
sbx-int-destroy:
	source ./environments/sbx/.env-int.sh
	terraform destroy -var-file=./environments/sbx/int.tfvars
sbx-ext:
	rm -rf .terraform
	source ./environments/sbx/.env-ext.sh
	terraform init -backend-config=./environments/sbx/backend-ext.hcl
	terraform workspace select ext
	terraform plan -var-file=./environments/sbx/ext.tfvars -out=./plan/plan-sbx-ext
	terraform graph -type=plan | dot -Tsvg > ./images/sbx-ext-plan.svg
	terraform apply "./plan/plan-sbx-ext"
	az aks get-credentials --name ofg-sbx-e-aks --resource-group  ofg-sbx-e-aks-rg --admin --overwrite-existing
	az aks update --name ofg-sbx-e-aks --resource-group  ofg-sbx-e-aks-rg --attach-acr "/subscriptions/1dda66b2-2d18-40b8-98c4-6fb5471bdbea/resourceGroups/common-rer-rg/providers/Microsoft.ContainerRegistry/registries/commonrercr"
sbx-ext-destroy:
	source ./environments/sbx/.env-ext.sh
	terraform destroy -var-file=./environments/sbx/ext.tfvars