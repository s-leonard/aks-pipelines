

terraform init


terraform apply 


echo "azure_subscription_id=\"$(terraform output azure_subscription_id)\"" >>../local/terraform.tfvars

bash local.sh
