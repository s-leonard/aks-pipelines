provider "azurerm" {
    version = "~>1.5"
}

provider "azuread" {
  version = "~>0.7.0"
}

provider "random" {
  version = "~> 2.2"
}

provider "tls" {
  version = "~> 2.1"
}

terraform {
   # backend "azurerm" {}
}


resource "azurerm_resource_group" "k8s" {
    name     = var.resource_group_name
    location = var.location
}

resource "random_id" "k8s" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.k8s.name
  }

  byte_length = 2
}

