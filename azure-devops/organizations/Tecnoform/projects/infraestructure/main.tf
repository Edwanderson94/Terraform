# ================================================================
# Azure DevOps - Infrastructure project repositories
# ================================================================

module "azuredevops_repositories" {
  source = "git::https://github.com/Edwanderson94/Terraform-Modules.git//azure_devops/repos?ref=v1.3.2"

  org_service_url               = var.org_service_url
  personal_access_token         = var.personal_access_token
  project_name                  = var.project_name
  repositories                  = local.repositories
  repository_branches           = local.repository_branches
  repository_branch_renames     = local.repository_branch_renames
  repository_branches_to_delete = local.repository_branches_to_delete
}
