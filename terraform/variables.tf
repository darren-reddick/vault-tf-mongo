variable "vault_token" {
  type        = string
  description = "The root token for vault"
  sensitive   = true
}

variable "mongo_admin" {
  type        = string
  description = "The root admin password for mongodb"
  sensitive   = true
}