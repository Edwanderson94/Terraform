# ================================================================
# Owner: Edwanderson
# Description: Provisionando Repositórios e suas Configurações
# Project: Azure DevOps com Terraform
# =================================================================

output "module_repository_names" {
  value = module.azuredevops_repository.repository_names
}

output "module_repository_ids" {
  value = module.azuredevops_repository.repository_ids
}

output "module_repository_default_branch" {
  value = module.azuredevops_repository.repository_default_branch
}
