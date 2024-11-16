# ======================================================
# Owner: Edwanderson
# Description: Provisionando Projeto e Configurações
# Project: Azure DevOps com Terraform
# =======================================================

# ======================================================
# Módulo de Criação de repositório
# ======================================================
module "azuredevops_repository" {
#  source                       = ""
  source = "git::https://Edwanderson94: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@github.com/Edwanderson94/Terraform-Modules.git//terraform-azdo-modules/azuredevops_repository?ref=develop"
  create_multiple_repositories = true # Flag para múltiplos repositórios
  project_id                   = data.azuredevops_project.project_infra.id
  org_service_url              = var.org_service_url
  personal_access_token        = var.personal_access_token

  repositories = var.repositories # Passando apenas a lista de repositórios
}