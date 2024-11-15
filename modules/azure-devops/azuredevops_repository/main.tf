# ================================================================
# Owner: Edwanderson
# Description: Módulo de Criação de Repositórios
# Project: Módulo de Terraform para Azure DevOps
# =================================================================

resource "azuredevops_git_repository" "repository_01" {
  project_id     = data.azuredevops_project.project_infra.id
  name           = var.repository_name
  default_branch = "refs/heads/${var.default_branch}"    # Concatenando "refs/heads/"
  initialization {
    init_type = "Clean"
  }
}