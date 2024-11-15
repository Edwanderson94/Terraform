# ======================================================
# Owner: Edwanderson
# Description: Provisionando Projeto e Configurações 
# Project: Azure DevOps com Terraform
# =======================================================

# ============================================================
# Captura de informações sobre Projeto
# ============================================================
data "azuredevops_project" "project_infra" {
  name = "Infrastructure"
}

# ============================================================
# Captura de dados do Repositório Infrastructure
# - Desativando o repositório default
# - Este repo é criado por default quando o projeto é criado.
# ============================================================
data "azuredevops_git_repository" "data_repo_01" {
  project_id = data.azuredevops_project.project_infra.id
  name       = "Infrastructure"
}