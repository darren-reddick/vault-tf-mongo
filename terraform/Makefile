init:
	terraform init

apply:
	terraform apply -var="vault_token=$(VAULT_ROOT)" -var="mongo_admin=$(MONGOADMIN_PW)"

fmt:
	terraform fmt -recursive .

destroy:
	terraform destroy -var="vault_token=$(VAULT_ROOT)" -var="mongo_admin=$(MONGOADMIN_PW)"