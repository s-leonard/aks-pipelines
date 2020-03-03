# When running in a pipeline azurerm provider is defined here and will run under a service principal, which has contributor rights to the subscription.
# The details for the this are stored in env/terraform.tfvars 
provider "azurerm" {
  version         = "~>1.5"
  subscription_id = var.azure_subscription_id
  client_id       = var.azure_subscription_client_id
  client_secret   = var.azure_subscription_client_secret
  tenant_id       = var.azure_tenant_id
}

provider "azuread" {
  version = "~>0.7.0"
  subscription_id = var.azure_subscription_id
  client_id       = var.azure_subscription_client_id
  client_secret   = var.azure_subscription_client_secret
  tenant_id       = var.azure_tenant_id
}
# When running in a pipeline the terraform state fil is stored in Azure not locally. 
# azure-pipelines.yml file sets the storage account details on terraform init 
terraform {
   backend "azurerm" {
      resource_group_name = var.tf_backend_resource_group
      storage_account_name = var.tf_backend_storage_account
      container_name = var.tf_backend_container_name
      key = var.tf_backend_state_file_name
      access_key = var.tf_backend_state_file_key
   }
}



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

