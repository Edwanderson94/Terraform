# ================================================================
# Azure DevOps - Infrastructure repositories
# ================================================================

locals {
  repository_default_branch = "master"
  repository_branches       = ["develop", "homolog", "master"]

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

  repository_branches_to_delete = {
    aws   = ["main"]
    azure = ["uat"]
    gcp   = ["main"]
  }
}
