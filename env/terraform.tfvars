#These keys are actually stored in key vault, then brought into a variable group for the pipeline and then merged into this file during the pipleines replace tokens task in azure-pipelines.yml
subscription-id="#{subscriptionid}#"
client-id="#{clientid}#"
client-secret="#{clientsecret}#"
tenant-id="#{tenantid}#"