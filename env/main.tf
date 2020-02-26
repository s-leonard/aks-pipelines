# When running in a pipeline azurerm provider is defined here and will run under a service principal, which has contributor rights to the subscription.
# The details for the this are stored in env/terraform.tfvars 
provider "azurerm" {
  version         = "~>1.5"
  subscription_id = var.subscription-id
  client_id       = var.client-id
  client_secret   = var.client-secret
  tenant_id       = var.tenant-id
}

provider "azuread" {
  version = "~>0.7.0"
  subscription_id = var.subscription-id
  client_id       = var.client-id
  client_secret   = var.client-secret
  tenant_id       = var.tenant-id
}
# When running in a pipeline the terraform state fil is stored in Azure not locally. 
# azure-pipelines.yml file sets the storage account details on terraform init 
terraform {
   backend "azurerm" {
   }
}


module "k8s" {
  source = "./k8s-cluster"
}