resource "azuread_application" "k8s" {
  name                       = "${var.resource_group_name}${random_id.k8s.dec}"
  homepage                   = "https://homepage${random_id.k8s.dec}"
  identifier_uris            = ["https://uri${random_id.k8s.dec}"]
  reply_urls                 = ["https://uri${random_id.k8s.dec}"]
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = true
}

# We need to wrap it up in a service principal so we can assign it credentials
resource "azuread_service_principal" "k8s" {
  application_id = azuread_application.k8s.application_id
}

# Generate a password for our service principal
resource "random_string" "k8s" {
  length  = "32"
  special = true
}

# Set the password of the service principal
resource "azuread_service_principal_password" "k8s" {
  service_principal_id = azuread_service_principal.k8s.id
  value                = random_string.k8s.result
  end_date             = "2022-01-01T01:02:03Z"
}

resource "azurerm_role_assignment" "k8s" {
  scope              = azurerm_resource_group.k8s.id
  role_definition_name = "Network Contributor"
  principal_id       = azuread_service_principal.k8s.id
}

resource "azurerm_role_assignment" "aksmonitor" {
  scope              = azurerm_resource_group.k8s.id
  role_definition_name = "Monitoring Metrics Publisher"
  principal_id       = azuread_service_principal.k8s.id
}