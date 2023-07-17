// enable database engine for mongo at path "mongodb"
resource "vault_database_secrets_mount" "db" {
  path = "mongodb"

  mongodb {
    name           = "db1"
    username       = "mdbadmin"
    password       = var.mongo_admin
    connection_url = "mongodb://{{username}}:{{password}}@mongo/admin?tls=false"
    allowed_roles = [
      "dbtester",
    ]
  }
}

// create a readwrite dynamic role for accessing the test1 database
resource "vault_database_secret_backend_role" "role" {
  backend             = vault_database_secrets_mount.db.path
  name                = "dbtester"
  db_name             = vault_database_secrets_mount.db.mongodb[0].name
  // creation statements get passed to the roles field of mongo shell command db.createUser()
  // https://www.mongodb.com/docs/manual/reference/method/db.createUser/
  creation_statements = ["{ \"db\": \"admin\", \"roles\": [{ \"role\": \"readWrite\", \"db\":\"test1\" }] }"]
}

// created an entity with the dbread policy enabled
resource "vault_identity_entity" "dbreader1" {
  name      = "dbreader1"
  policies  = ["dbread"]

}

// enable userpass auth method
resource "vault_auth_backend" "userpass" {
  type = "userpass"
}

// create a user for the userpass auth method
resource "vault_generic_endpoint" "u1" {
  depends_on           = [vault_auth_backend.userpass]
  path                 = "auth/userpass/users/u1"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["p1"],
  "password": "changeme"
}
EOT
}

// create an alias to link the dbreader1 entity with the userpass login
resource "vault_identity_entity_alias" "dbreader1_userpass" {
  name            = "u1"
  mount_accessor  = vault_auth_backend.userpass.accessor
  canonical_id    = vault_identity_entity.dbreader1.id
}

// create a policy to access the dynamic database role
resource "vault_policy" "dbread" {
  name = "dbread"

  policy = <<EOT
path "mongodb/creds/dbtester" {
  capabilities = ["read","list"]
}
EOT
}
