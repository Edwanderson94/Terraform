# ================================================================
# Outputs
# ================================================================

output "module_version" {
  description = "Versao do modulo de repositorios Azure DevOps"
  value       = module.azuredevops_repositories.module_version
}

output "repository_branches" {
  description = "Branches padronizadas nos repositorios"
  value       = module.azuredevops_repositories.repository_branches
}

output "repository_urls" {
  description = "URLs dos repositorios gerenciados"
  value       = module.azuredevops_repositories.repository_urls
}

output "environment_ids" {
  description = "IDs dos Environments existentes adotados por import declarativo."
  value       = { for key, environment in module.azuredevops_environments : key => environment.id }
}
