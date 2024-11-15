# ======================================================
# Owner: Edwanderson
# Description: Provisionando Projeto e Configurações 
# Project: Azure DevOps com Terraform
# =======================================================

# ======================================================
# Módulo de Criação de repositório
# ======================================================
module "azuredevops_repository" {
  source                  = "../../../../../modules/azure-devops/azuredevops_repository"
  project_id              = data.azuredevops_project.project_infra.id
  repository_name         = var.repository_name
  default_branch          = var.default_branch
  org_service_url         = var.org_service_url
  personal_access_token   = var.personal_access_token
}