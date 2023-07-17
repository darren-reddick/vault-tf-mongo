# Vault-tf-mongo

Quick project to demonstrate using terraform to configure the mongodb database engine in vault to generate dynamic db credentials.

## Prerequisites

- docker desktop
- terraform >=1.0

## Deployment

1. Create the vault and mongodb containers
    ```
    make docker-run
    ```

    This will run vault (in dev mode) and a mongo database with a **test1.containers** collection with sample data. See [database initialization script](database/init-db.js)

1. Initialize terraform
    ```
    make tf-init
    ```
1. Deploy vault configuration with terraform
    ```
    make tf-apply
    ```

    Terraform will configure the database backend to connect to mongo and a role to access a database

## Testing

1. Login to vault with the **u1** user
    ```
    vault login -method=userpass username=u1 password=changeme
    ```

    This uses the userpass method to login as the u1 user configured by terraform

1. Store the token from output above to the **VAULT_TOKEN** environment variable
    ```
    export VAULT_TOKEN=[token]
    ```
1. Obtain temp db credentials for mongodb using the dbtester vault role
    ```
    vault read mongodb/creds/dbtester
    ```

    This will obtain temporary credentials for login to mongo using the dbtester backend role

1. Connect to the database using mongo shell - substitute the credentials from above (username / password)
    ```
    docker exec -it mongo mongosh --username [username] --password [password] --authenticationDatabase admin
    ```
1. In the mongo shell list the documents in the **container** collection in the **test1** database created
    ```
    use test1
    db.container.find()
    ```

    This proves that the temporary credentials obtained from vault are valid.