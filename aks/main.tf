terraform {
    required_version = ">=0.13"

    backend "azurerm" {
        key = "prod.terraform.tfstate"
    }

    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "~>2.20"
        }

        azuread = {
            source = "hashicorp/azuread"
            version = "~>1.0"
        }

        random = {
            source  = "hashicorp/random"
            version = "~> 3.0"
        }
    }
}

locals {
    aks_cluster_name    = "b59s-aks"
    location            = "westeurope"
    resource_group_name = "b59s"
}

resource "random_pet" "primary" {}