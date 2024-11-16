# ================================================================
# Owner: Edwanderson
# Description: Provisionando Repositórios e suas Configurações
# Project: Azure DevOps com Terraform
# =================================================================

output "module_repository_names" {
  description = "Nome do repositório que foi criado a partir do módulo"
  value = module.azuredevops_repository.repository_names
}

output "module_repository_ids" {
  description = "ID do repositório que foi criado pelo módulo"
  value = module.azuredevops_repository.repository_ids
}

output "module_repository_default_branch" {
  description = "Branch Default do repositório que foi criado a partir do módulo"
  value = module.azuredevops_repository.repository_default_branch
}
