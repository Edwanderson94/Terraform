# ================================================================
# Owner: Edwanderson
# Description: Provisionando Repositórios e suas Configurações
# Project: Azure DevOps com Terraform
# =================================================================


# ======================================================
# Disable do Repositório Infrastructure
# ======================================================
resource "azuredevops_git_repository" "disable_repo_01" {
  project_id = data.azuredevops_project.project_infra.id
  name       = data.azuredevops_git_repository.data_repo_01.name
  disabled   = true
  initialization {
    init_type = "Import"
  }
}

# ======================================================
# Criação do Repositório Cloud-Azure-TF
# ======================================================
resource "azuredevops_git_repository" "create_repo_01" {
  project_id     = azuredevops_project.project_infra.id
  name           = "Cloud-Azure-TF"
  default_branch = "refs/heads/master"
  initialization {
    init_type = "Clean"
  }
}

# ======================================================
# Criação do Repositório Cloud-AWS-TF
# ======================================================
resource "azuredevops_git_repository" "create_repo_02" {
  project_id     = azuredevops_project.project_infra.id
  name           = "Cloud-AWS-TF"
  default_branch = "refs/heads/master"
  initialization {
    init_type = "Clean"
  }
}

# ======================================================
# Criação do Repositório Cloud-GCP-TF
# ======================================================
resource "azuredevops_git_repository" "create_repo_03" {
  project_id     = azuredevops_project.project_infra.id
  name           = "Cloud-GCP-TF"
  default_branch = "refs/heads/master"
  initialization {
    init_type = "Clean"
  }
}