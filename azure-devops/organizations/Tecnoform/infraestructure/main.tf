# ======================================================
# Owner: Edwanderson
# Description: Provisionando Projeto e Configurações 
# Project: Azure DevOps com Terraform
# =======================================================

# ======================================================
# Criação do Projeto Azure DevOps
# ======================================================
resource "azuredevops_project" "project_infra" {
  name               = "Infrastructure"
  visibility         = "private"
  version_control    = "Git"
  work_item_template = "Tecnoform Agile"
  description        = "Projeto destinado a automação de infraestruturas - Managed by Terraform"
}

# ======================================================
# Criação das Features do Projeto Azure DevOps
# ======================================================
resource "azuredevops_project_features" "project_infra_feature" {
  project_id = azuredevops_project.project_infra.id
  features = {
    "testplans"    = "disabled"
    "artifacts"    = "disabled"
    "boards"       = "disabled"
    "repositories" = "enabled"
    "pipelines"    = "enabled"
  }
}