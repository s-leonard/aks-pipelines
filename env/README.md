

At the prompt, retrieve your subscription ID by running the following command at the Cloud Shell prompt:
az account list --output table

Note: If you have multiple Azure subscriptions, and the account you are using for this hands-on lab is not your default account, you may need to run az account set --subscription <your-subscription-id> after running the command above to set the appropriate account for the following Azure CLI commands, replacing <your-subscription-id> with the appropriate value from the output list above.

In the output table, locate the subscription you are using for this hands-on lab, and copy the SubscriptionId value into a text editor, such as Notepad, for use below.

Next, enter the following az ad sp create-for-rbac command at the Cloud Shell prompt, replacing <your-subscription-id> with the value you copied above and <your-resource-group-name> with the name of your hands-on-lab-SUFFIX resource group, and then press Enter to run the command.

# Authorize an operation to create a container
Before you create the container, assign the Storage Blob Data Contributor role to yourself. Even though you are the account owner, you need explicit permissions to perform data operations against the storage account.

user_id=$(az ad signed-in-user show --query objectId --output tsv)
az role assignment create --assignee $user_id --role "Storage Blob Data Contributor" 


# Get List of Subscriptions
az account list --output table

# Set variables
appname=tfdemo
environment=dev
sub=1aa42b20-3482-4a30-bbed-c82350c97417
sub_scope=subscriptions/1aa42b20-3482-4a30-bbed-c82350c97417
rg_loc="UkSouth"
random=$(date +%s%N | md5sum | cut -c1-4)
rg_name=${appname}${environment}${random}
sp_name=${rg_name}${random}
ad_tenant=$(az account get-access-token --subscription $sub --query tenant --output tsv)

# Create Service Principal with owner role on subscription
sp_psw=$(az ad sp create-for-rbac --name $sp_name --role Owner --scopes $sub_scope --query password --output tsv)
sp_client=$(az ad sp show --id http://$sp_name --query appId --output tsv)

# Create resource group with storage account, container and state file blob
az group create --name $rg_name --location $rg_loc --subscription $sub

az storage account create --name "${rg_name}storage" --subscription $sub --resource-group $rg_name --location $rg_loc --sku Standard_ZRS --encryption-services blob

## this bit isnt working
sa_key=$(az storage account keys list --account-name "${rg_name}storage" --query [0].value --output tsv)
 az storage container create --name statefiles --subscription $sub --account-name "${rg_name}storage" --account-key "isPMRtuJmR0BDLydP/2MNkGIprpPmVoBjEIAOpnU7lQRme5QGByABHodzoxRexhOPoU1o2wUt65O6abk/ancXA==" --auth-mode key --public-access off 
az storage container create --name statefiles --subscription $sub --account-name "${rg_name}storage" --auth-mode login --public-access off 
 
az keyvault create --location $rg_loc --name tfvault${random} --resource-group $rg_name --subscription $sub

az keyvault secret set --name azure-subscription-id --vault-name tfvault${random} --value $sub
az keyvault secret set --name azure-subscription-client-id --vault-name tfvault${random} --value $sp_client
az keyvault secret set --name azure-subscription-client-secret --vault-name tfvault${random} --value $sp_psw
az keyvault secret set --name azure-tenant-id --vault-name tfvault${random} --value $ad_tenant
az keyvault secret set --name azure-backend-resource-group --vault-name tfvault${random} --value $rg_name
az keyvault secret set --name azure-backend-storage-account --vault-name tfvault${random} --value ${rg_name}storage
az keyvault secret set --name azure-backend-container-name --vault-name tfvault${random} --value statefiles
az keyvault secret set --name azure-backend-state-file-key --vault-name tfvault${random} --value sa_key
az keyvault secret set --name tf-backend-state-file-name --vault-name tfvault${random} --value ${appname}${environment}statefile.tfstate


azure_backend_resource_group="#{azure-backend-resource-group}#"
azure_backend_storage_account="#{azure-backend-storage-account}#"
azure_backend_container_name="#{azure-backend-container-name}#"
azure_backend_state_file_name="#{azure-backend-state-file-name}#"
azure_backend_state_file_key="#{azure-backend-state-file-key}#"
 
# Output used when creating Kubernetes secret.
echo "Service principal client ID: $sp_client"
echo "Service principal password: $sp_psw"
echo "Active Directory Tenant: $ad_tenant"
echo "Storage Account Key:  $sa_key"
