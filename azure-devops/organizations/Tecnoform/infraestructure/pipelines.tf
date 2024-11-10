# ======================================================
# Criação do Enviroments Azure DevOps | Pipelines
# ======================================================
resource "azuredevops_environment" "dev" {
  project_id = azuredevops_project.project_infra.id
  name       = "dev"
}

resource "azuredevops_environment" "uat" {
  project_id = azuredevops_project.project_infra.id
  name       = "uat"
}

resource "azuredevops_environment" "prod" {
  project_id = azuredevops_project.project_infra.id
  name       = "prod"
}