#These keys are actually stored in key vault, then brought into a variable group for the pipeline and then merged into this file during the pipleines replace tokens task in azure-pipelines.yml
azure_subscription_id="#{azure-subscription-id}#"
azure_subscription_client_id="#{azure-subscription-client-id}#"
azure_subscription_client_secret="#{azure-subscription-client-secret}#"
azure_tenant_id="#{azure-tenant-id}#"

tf_backend_resource_group="#{tf-backend-resource-group}#"
tf_backend_storage_account="#{tf-backend-storage-account}#"
tf_backend_container_name="#{tf-backend-container-name}#"
tf_backend_state_file_name="#{tf-backend-state-file-name}#"
tf_backend_state_file_key="#{tf-backend-state-file-key}#"

