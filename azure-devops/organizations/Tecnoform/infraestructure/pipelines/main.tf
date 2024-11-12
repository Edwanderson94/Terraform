# ======================================================
# Criação do Enviroments Azure DevOps | Pipelines
# ======================================================
resource "azuredevops_environment" "dev" {
  project_id = var.project_id
  name       = "dev"
}

resource "azuredevops_environment" "uat" {
  project_id = var.project_id
  name       = "uat"
}

resource "azuredevops_environment" "prod" {
  project_id = var.project_id
  name       = "prod"
}