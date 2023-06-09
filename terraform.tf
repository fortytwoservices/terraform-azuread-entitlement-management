terraform {
  required_version = ">=1.4.6"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = ">=2.39.0"
    }
  }
}