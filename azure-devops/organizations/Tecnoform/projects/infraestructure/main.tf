# ======================================================
# Owner: Edwanderson
# Description: Provisionando Projeto e Configurações
# Project: Azure DevOps com Terraform
# =======================================================

# ======================================================
# Módulo de Criação de repositório
# ======================================================
module "azuredevops_repository" {
#  source                       = "../../../../../modules/azure-devops/azuredevops_repository"
  source = "git::https://github.com/Edwanderson94/Terraform-Modules.git//azure-devops/azuredevops_repository?ref=develop"
  create_multiple_repositories = true # Flag para múltiplos repositórios
  project_id                   = data.azuredevops_project.project_infra.id
  org_service_url              = var.org_service_url
  personal_access_token        = var.personal_access_token

  repositories = var.repositories # Passando apenas a lista de repositórios
}