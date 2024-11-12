terraform {
  source = "./project_infra//"
}

# Configuração global do provider
provider "azuredevops" {
  org_service_url       = "https://dev.azure.com/Tecnoform"
  personal_access_token = "pat"
}
