terraform {
  required_version = ">=1.4.6"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = ">=2.39.0"
    }
    msgraph = {
      source  = "microsoft/msgraph"
      version = ">=0.2.0"
    }
  }
}
