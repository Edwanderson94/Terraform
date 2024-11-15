# ================================================================
# Owner: Edwanderson
# Description: Provisionando Repositórios e suas Configurações
# Project: Azure DevOps com Terraform
# =================================================================

# ======================================================
# Output do repositório criado pelo módulo
# ======================================================
output "module_repository_name" {
  description = "The name of the Azure DevOps repository from the module"
  value       = module.azuredevops_repository.repository_name
}

# ======================================================
# Output da branch criado pelo módulo
# ======================================================
output "module_repository_default_branch" {
  description = "The default branch of the Azure DevOps repository from the module"
  value       = module.azuredevops_repository.repository_default_branch
}
