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

  repository_default_branches = {
    aws   = "main"
    oci   = "develop"
    azure = "uat"
    gcp   = "main"
  }

  repositories = {
    for key, name in local.repository_names : key => {
      name           = name
      default_branch = local.repository_default_branches[key]
    }
  }
}

inputs = {
  project_name = "Infrastructure"
  repositories = local.repositories
}
