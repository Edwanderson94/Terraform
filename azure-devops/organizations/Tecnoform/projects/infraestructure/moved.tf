# ================================================================
# State moves from the previous Terragrunt-only execution model
# ================================================================

moved {
  from = azuredevops_git_repository.repositories["aws"]
  to   = module.azuredevops_repositories.azuredevops_git_repository.repositories["aws"]
}

moved {
  from = azuredevops_git_repository.repositories["azure"]
  to   = module.azuredevops_repositories.azuredevops_git_repository.repositories["azure"]
}

moved {
  from = azuredevops_git_repository.repositories["gcp"]
  to   = module.azuredevops_repositories.azuredevops_git_repository.repositories["gcp"]
}

moved {
  from = azuredevops_git_repository.repositories["oci"]
  to   = module.azuredevops_repositories.azuredevops_git_repository.repositories["oci"]
}

moved {
  from = null_resource.repository_branch_standard["aws"]
  to   = module.azuredevops_repositories.null_resource.repository_branch_standard["aws"]
}

moved {
  from = null_resource.repository_branch_standard["azure"]
  to   = module.azuredevops_repositories.null_resource.repository_branch_standard["azure"]
}

moved {
  from = null_resource.repository_branch_standard["gcp"]
  to   = module.azuredevops_repositories.null_resource.repository_branch_standard["gcp"]
}

moved {
  from = null_resource.repository_branch_standard["oci"]
  to   = module.azuredevops_repositories.null_resource.repository_branch_standard["oci"]
}
