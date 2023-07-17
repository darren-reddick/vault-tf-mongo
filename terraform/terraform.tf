terraform {
  required_version = ">= 1.0"
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.17.0"
    }
  }
}

provider "vault" {
  token = var.vault_token
}

