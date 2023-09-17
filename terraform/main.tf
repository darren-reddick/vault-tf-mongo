module vault {
    source = "./vault"
    providers = {
        vault = vault.this
    }
    vault_token = var.vault_token
    mongo_admin = var.mongo_admin
}

