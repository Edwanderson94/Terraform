# ======================================================
# owner: 
# description: 
# project: azure devops
# =======================================================


# ======================================================
# Criação do Projeto Azure DevOps
# ======================================================
resource "azuredevops_project" "project_infra" {
  name               = "Infrastructure"
  visibility         = "private"
  version_control    = "Git"
  work_item_template = "Tecnoform Agile"
  description        = "Managed by Terraform"
}

# ======================================================
# Criação das Features do Projeto Azure DevOps
# ======================================================
resource "azuredevops_project_features" "project_infra_feature" {
  project_id = azuredevops_project.project_infra.id
  features = {
    "testplans" = "disabled"
    "artifacts" = "disabled"
  }
}

# ======================================================
# Criação do Enviroments Azure DevOps
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