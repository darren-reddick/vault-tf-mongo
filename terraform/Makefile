init:
	terraform init

apply:
	terraform apply -var="vault_token=$(VAULT_ROOT)" -var="mongo_admin=$(MONGOADMIN_PW)"

fmt:
	terraform fmt -recursive .

destroy:
	terraform destroy -var="vault_token=$(VAULT_ROOT)" -var="mongo_admin=$(MONGOADMIN_PW)"



docker run -v $(pwd)/terraform:/terraform --workdir /terraform hashicorp/terraform:0.12.20 init
docker run -v $(pwd)/terraform:/terraform --net=dev --workdir /terraform hashicorp/terraform:0.12.20 plan -var="vault_token=root" -var="mongo_admin=admin" -out plan.out

docker run -v $(pwd)/terraform:/terraform --net=dev --workdir /terraform hashicorp/terraform:0.12.20 apply plan.out