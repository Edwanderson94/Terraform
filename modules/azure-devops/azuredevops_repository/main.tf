# ================================================================
# Owner: Edwanderson
# Description: Módulo de Criação de Repositórios
# Project: Módulo de Terraform para Azure DevOps
# =================================================================

resource "azuredevops_git_repository" "repository" {
  project_id     = var.project_id
  name           = var.repository_name
  initialize     = true
  default_branch = var.default_branch
}