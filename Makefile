MONGOADMIN_PW ?= admin
VAULT_ROOT ?= root
export MONGOADMIN_PW VAULT_ROOT

docker-mongo:
	docker run -d \
		--net=dev \
		-p 27017:27017 -p 28017:28017 \
		--name=mongo \
		-e MONGO_INITDB_ROOT_USERNAME="mdbadmin" \
		-e MONGO_INITDB_ROOT_PASSWORD="$(MONGOADMIN_PW)" \
		-e 'MONGO_INITDB_DATABASE=test1' \
		-v $(shell pwd)/database/init-db.js:/docker-entrypoint-initdb.d/init-db.js \
		mongo

docker-vault:
	docker run --cap-add=IPC_LOCK -p 8200:8200 -e 'VAULT_DEV_ROOT_TOKEN_ID=$(VAULT_ROOT)' --net="dev" -d --name=vault hashicorp/vault


docker-network:
	docker network create dev

docker-run: docker-network docker-vault docker-mongo

docker-rm:
	-docker rm -f mongo vault
	-docker network rm dev
	-docker volume prune -f

tf-init:
	exit 0
	$(MAKE) -C terraform init

tf-apply:
	$(MAKE) -C terraform apply

tf-fmt:
	$(MAKE) -C terraform fmt

tf-destroy:
	$(MAKE) -C terraform destroy