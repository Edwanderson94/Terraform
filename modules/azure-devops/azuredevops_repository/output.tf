# ================================================================
# Output
# ================================================================

output "repository_ids" {
  description = "IDs dos repositórios criados"
  value = [for repo in azuredevops_git_repository.repositories : repo.id]
}

output "repository_names" {
  description = "Nomes dos repositórios criados"
  value = [for repo in azuredevops_git_repository.repositories : repo.name]
}

output "repository_default_branch" {
  description = "O branch padrão dos repositórios criados"
  value = { for repo_name, repo in azuredevops_git_repository.repositories : repo_name => repo.default_branch }
}