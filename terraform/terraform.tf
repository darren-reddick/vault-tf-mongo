terraform {
#  required_providers {
#    vault = {
#      source  = "hashicorp/vault"
#      version = "~> 3.17.0"
#    }
#  }
}

provider "vault" {
  token = var.vault_token
  address = "http://vault:8200"
  alias = "this"
}

