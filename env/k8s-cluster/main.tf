# azurerm provider and azuread provider are defined in the folder above with the a subscription and tenant selected, with a service princials ID and secret
# when running 'terraform apply' on the k8s-cluster directory you need to first run 'az login' for terraform to run under your user. 
# Terraform will automatically get the lastest providers on 'Terraform Init'
# If the version is above 1.5 and 0.7 and something fails, uncomment this code below when running locally

/*
provider "azurerm" {
    version = "~>1.5"
}

provider "azuread" {
  version = "~>0.7.0"
}
*/

provider "random" {
  version = "~> 2.2"
}

provider "tls" {
  version = "~> 2.1"
}

resource "azurerm_resource_group" "k8s" {
    name     = var.resource_group_name
    location = var.location
}

resource "random_id" "k8s" {
  keepers = {
    resource_group = azurerm_resource_group.k8s.name
  }
  byte_length = 2
}

