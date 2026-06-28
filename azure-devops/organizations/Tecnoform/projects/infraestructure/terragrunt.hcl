# Includes the shared Terragrunt configuration for the Tecnoform organization.
include {
  path = find_in_parent_folders("root.hcl")
}

locals {
  repository_names = {
    aws   = "cloud-aws-infra"
    oci   = "cloud-oci-infra"
    azure = "cloud-azure-infra"
    gcp   = "cloud-gcp-infra"
  }

  repository_default_branch = "master"
  repository_branches       = ["develop", "homolog", "master"]

  repositories = {
    for key, name in local.repository_names : key => {
      name           = name
      default_branch = local.repository_default_branch
    }
  }
}

inputs = {
  project_name              = "Infrastructure"
  repositories              = local.repositories
  repository_branches       = local.repository_branches
  repository_branch_renames = {}
  repository_branches_to_delete = {
    aws   = ["main"]
    azure = ["uat"]
    gcp   = ["main"]
  }
}
