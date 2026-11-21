# ================================================================
# Azure DevOps - Infrastructure repositories
# ================================================================

locals {
  repository_default_branch = "master"
  repository_branches       = ["master"]

  repositories = {
    aws = {
      name           = "cloud-aws-infra"
      default_branch = local.repository_default_branch
    }

    oci = {
      name           = "cloud-oci-infra"
      default_branch = local.repository_default_branch
    }

    azure = {
      name           = "cloud-azure-infra"
      default_branch = local.repository_default_branch
    }

    gcp = {
      name           = "cloud-gcp-infra"
      default_branch = local.repository_default_branch
    }

    terraform_state = {
      name           = "terraform-state"
      default_branch = local.repository_default_branch
    }
  }

  repository_branch_renames = {}

  # Existing Environments are adopted by import; preserve names and IDs.
  environments = {
    oci_bootstrap = {
      name        = "terraform-oci-bootstrap"
      description = "Automatically created environment"
      id          = 12
    }
    aws_cloud = {
      name        = "terraform-aws-cloud"
      description = "Environment de aprovacao da pipeline AWS"
      id          = 13
    }
  }

  repository_branches_to_delete = {
    aws   = ["main"]
    azure = ["uat"]
    gcp   = ["main"]
  }
}
