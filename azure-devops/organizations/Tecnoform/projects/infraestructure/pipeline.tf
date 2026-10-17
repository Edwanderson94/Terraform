# The Infrastructure project owns the Azure DevOps pipeline definition, while
# the YAML and reusable Terraform/Terragrunt logic live in their Git repos.
data "azuredevops_project" "infrastructure" {
  name = var.project_name
}

data "azuredevops_git_repositories" "terraform_state" {
  project_id = data.azuredevops_project.infrastructure.id
  name       = "terraform-state"
}

module "terraform_state_bootstrap_pipeline" {
  # This branch ref is temporary for module development. Replace it with an
  # immutable tag/commit after the module is committed and published.
  source = "git::https://github.com/Edwanderson94/Terraform-Modules.git//azure_devops/pipelines?ref=feature/oci-object-storage-bucket"

  project_id    = data.azuredevops_project.infrastructure.id
  name          = "Terraform State OCI Bootstrap"
  repository_id = one(data.azuredevops_git_repositories.terraform_state.repositories[*].id)
  branch_name   = "refs/heads/feature/terraform-state-bootstrap"
  yml_path      = "/azure-pipelines.yml"
  path          = "\\"
}
