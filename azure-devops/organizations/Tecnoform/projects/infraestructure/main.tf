# ======================================================
# Owner: Edwanderson
# Description: Provisionando Projeto e Configurações
# Project: Azure DevOps com Terraform
# =======================================================

# ======================================================
# Módulo de Criação de repositório
# ======================================================
module "azuredevops_repository" {
  source                = "git::https://github.com/Edwanderson94/Terraform-Modules.git//azure_devops/terraform-azuredevops-repositorios?ref=develop"
  project_name          = var.project_name
  org_service_url       = var.org_service_url
  repositories          = var.repositories
  personal_access_token = var.personal_access_token
}
