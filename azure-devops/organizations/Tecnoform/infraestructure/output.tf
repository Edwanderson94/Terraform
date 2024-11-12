# ================================================================
# Owner: Edwanderson
# Description: Provisionando Repositórios e suas Configurações
# Project: Azure DevOps com Terraform
# =================================================================


# ======================================================
# Output do Repositório Infraestrutcture
# ======================================================
output "project_infra" {
  value = {
    project_name       = azuredevops_project.project_infra.name
    project_id         = azuredevops_project.project_infra.id
    visibility         = azuredevops_project.project_infra.visibility
    version_control    = azuredevops_project.project_infra.version_control
    work_item_template = azuredevops_project.project_infra.work_item_template
  }
}

