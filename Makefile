.ONESHELL:
SHELL=/bin/bash

.PHONY: 
qa-int:
	rm -rf .terraform
	source ./environments/qa/.env-int.sh
	terraform init -backend-config=./environments/qa/backend-int.hcl
	terraform workspace select qa-int
	terraform plan -var-file=./environments/qa/int.tfvars -out=./plan/plan-qa-int
	terraform graph -type=plan | dot -Tsvg > ./images/qa-int-plan.svg
	terraform apply "./plan/plan-qa-int"
	source ./environments/qa/.env-int.sh
	az aks get-credentials --name ofg-qa-i-aks --resource-group  ofg-qa-i-aks-rg --admin --overwrite-existing
	az aks update --name ofg-qa-i-aks --resource-group ofg-qa-i-aks-rg --attach-acr "/subscriptions/1dda66b2-2d18-40b8-98c4-6fb5471bdbea/resourceGroups/common-rer-rg/providers/Microsoft.ContainerRegistry/registries/commonrercr"
qa-int-destroy:
	source ./environments/qa/.env-int.sh
	terraform destroy -var-file=./environments/qa/int.tfvars
qa-ext:
	rm -rf .terraform
	source ./environments/qa/.env-ext.sh
	terraform init -backend-config=./environments/qa/backend-ext.hcl
	rm -f plan-qa-ext
	terraform workspace select qa-ext
	terraform plan -var-file=./environments/qa/ext.tfvars -out=./plan/plan-qa-ext
	terraform graph -type=plan | dot -Tsvg > ./images/qa-ext-plan.svg
	terraform apply "./plan/plan-qa-ext"
	source ./environments/qa/.env-ext.sh
	az aks get-credentials --name ofg-qa-e-aks --resource-group  ofg-qa-e-aks-rg --admin --overwrite-existing
	az aks update --name ofg-qa-e-aks --resource-group ofg-qa-e-aks-rg --attach-acr "/subscriptions/1dda66b2-2d18-40b8-98c4-6fb5471bdbea/resourceGroups/common-rer-rg/providers/Microsoft.ContainerRegistry/registries/commonrercr"
qa-ext-destroy:
	source ./environments/qa/.env-ext.sh
	terraform destroy -var-file=./environments/qa/ext.tfvars
uat-int:
	rm -rf .terraform
	source ./environments/uat/.env-int.sh
	terraform init -backend-config=./environments/uat/backend-int.hcl
	terraform workspace select uat-int
	terraform plan -var-file=./environments/uat/int.tfvars -out=./plan/plan-uat-int
	terraform graph -type=plan | dot -Tsvg > ./images/uat-int-plan.svg
	terraform apply "./plan/plan-uat-int"
	source ./environments/uat/.env-int.sh
	az aks get-credentials --name ofg-uat-i-aks --resource-group  ofg-uat-i-aks-rg --admin --overwrite-existing
	az aks update --name ofg-uat-i-aks --resource-group  ofg-uat-i-aks-rg --attach-acr "/subscriptions/1dda66b2-2d18-40b8-98c4-6fb5471bdbea/resourceGroups/common-rer-rg/providers/Microsoft.ContainerRegistry/registries/commonrercr"
uat-int-destroy:
	source ./environments/uat/.env-int.sh
	terraform destroy -var-file=./environments/uat/int.tfvars
uat-ext:
	rm -rf .terraform
	source ./environments/uat/.env-ext.sh
	terraform init -backend-config=./environments/uat/backend-ext.hcl
	terraform workspace select uat-ext
	terraform plan -var-file=./environments/uat/ext.tfvars -out=./plan/plan-uat-ext
	terraform graph -type=plan | dot -Tsvg > ./images/uat-ext-plan.svg
	terraform apply "./plan/plan-uat-ext"
	source ./environments/uat/.env-ext.sh
	az aks get-credentials --name ofg-uat-e-aks --resource-group  ofg-uat-e-aks-rg --admin --overwrite-existing
	az aks update --name ofg-uat-e-aks --resource-group  ofg-uat-e-aks-rg --attach-acr "/subscriptions/1dda66b2-2d18-40b8-98c4-6fb5471bdbea/resourceGroups/common-rer-rg/providers/Microsoft.ContainerRegistry/registries/commonrercr"
uat-ext-destroy:
	source ./environments/uat/.env-ext.sh
	terraform destroy -var-file=./environments/uat/ext.tfvars
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

data-int:
	rm -rf .terraform
	source ./environments/data/.env-int.sh
	terraform init -backend-config=./environments/data/backend-int.hcl
	terraform workspace select int
	terraform plan -var-file=./environments/data/int.tfvars -out=./plan/plan-data-int
	terraform graph -type=plan | dot -Tsvg > ./images/data-int-plan.svg
	terraform apply "./plan/plan-data-int"
	source ./environments/data/.env-int.sh
	az aks get-credentials --name ofg-data-i-aks --resource-group  ofg-data-i-aks-rg --admin --overwrite-existing
	az aks update --name ofg-data-i-aks --resource-group  ofg-data-i-aks-rg --attach-acr "/subscriptions/1dda66b2-2d18-40b8-98c4-6fb5471bdbea/resourceGroups/common-rer-rg/providers/Microsoft.ContainerRegistry/registries/commonrercr"
data-int-destroy:
	source ./environments/data/.env-int.sh
	terraform destroy -var-file=./environments/data/int.tfvars
data-ext:
	rm -rf .terraform
	source ./environments/data/.env-ext.sh
	terraform init -backend-config=./environments/data/backend-ext.hcl
	terraform workspace select ext
	terraform plan -var-file=./environments/data/ext.tfvars -out=./plan/plan-data-ext
	terraform graph -type=plan | dot -Tsvg > ./images/data-ext-plan.svg
	terraform apply "./plan/plan-data-ext"
	source ./environments/data/.env-ext.sh
	az aks get-credentials --name ofg-data-e-aks --resource-group  ofg-data-e-aks-rg --admin --overwrite-existing
	az aks update --name ofg-data-e-aks --resource-group  ofg-data-e-aks-rg --attach-acr "/subscriptions/1dda66b2-2d18-40b8-98c4-6fb5471bdbea/resourceGroups/common-rer-rg/providers/Microsoft.ContainerRegistry/registries/commonrercr"
data-ext-destroy:
	source ./environments/data/.env-ext.sh
	terraform destroy -var-file=./environments/data/ext.tfvars -auto-approve


dev-int:
	rm -rf .terraform
	source ./environments/dev/.env-int.sh
	terraform init -backend-config=./environments/dev/backend-int.hcl
	terraform workspace select int
	terraform plan -var-file=./environments/dev/int.tfvars -out=./plan/plan-dev-int
	terraform graph -type=plan | dot -Tsvg > ./images/dev-int-plan.svg
	terraform apply "./plan/plan-dev-int"
	source ./environments/dev/.env-int.sh
	az aks get-credentials --name ofg-dev-i-aks --resource-group  ofg-dev-i-aks-rg --admin --overwrite-existing
	az aks update --name ofg-dev-i-aks --resource-group  ofg-dev-i-aks-rg --attach-acr "/subscriptions/1dda66b2-2d18-40b8-98c4-6fb5471bdbea/resourceGroups/common-rer-rg/providers/Microsoft.ContainerRegistry/registries/commonrercr"
dev-int-destroy:
	source ./environments/dev/.env-int.sh
	terraform destroy -var-file=./environments/dev/int.tfvars
dev-ext:
	rm -rf .terraform
	source ./environments/dev/.env-ext.sh
	terraform init -backend-config=./environments/dev/backend-ext.hcl
	terraform workspace select ext
	terraform plan -var-file=./environments/dev/ext.tfvars -out=./plan/plan-dev-ext
	terraform graph -type=plan | dot -Tsvg > ./images/dev-ext-plan.svg
	terraform apply "./plan/plan-dev-ext"
	source ./environments/dev/.env-ext.sh
	az aks get-credentials --name ofg-dev-e-aks --resource-group  ofg-dev-e-aks-rg --admin --overwrite-existing
	az aks update --name ofg-dev-e-aks --resource-group  ofg-dev-e-aks-rg --attach-acr "/subscriptions/1dda66b2-2d18-40b8-98c4-6fb5471bdbea/resourceGroups/common-rer-rg/providers/Microsoft.ContainerRegistry/registries/commonrercr"
dev-ext-destroy:
	source ./environments/dev/.env-ext.sh
	terraform destroy -var-file=./environments/dev/ext.tfvars -auto-approve

