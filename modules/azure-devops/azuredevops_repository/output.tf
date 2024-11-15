# ================================================================
# Output
# ================================================================

output "repository_name" {
  description = "The name of the Azure DevOps repository"
  value       = azuredevops_git_repository.repository_01.name
}

output "repository_default_branch" {
  description = "The default branch of the Azure DevOps repository"
  value       = azuredevops_git_repository.repository_01.default_branch
}
