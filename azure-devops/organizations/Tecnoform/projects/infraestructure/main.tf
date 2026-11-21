# ================================================================
# Azure DevOps - Infrastructure project repositories
# ================================================================

module "azuredevops_repositories" {
  source = "git::https://github.com/Edwanderson94/Terraform-Modules.git//azure_devops/repos?ref=4cc38f6d384cd1ce9916ba0ef57f6a5a34a29b84"

  manage_repository_branches = false

  org_service_url               = var.org_service_url
  personal_access_token         = var.personal_access_token
  project_name                  = var.project_name
  repositories                  = local.repositories
  repository_branches           = local.repository_branches
  repository_branch_renames     = local.repository_branch_renames
  repository_branches_to_delete = local.repository_branches_to_delete
}

module "azuredevops_variablegroup" {
  source = "git::https://github.com/Edwanderson94/Terraform-Modules.git//azure_devops/variable-groups?ref=cfc19ec6bde0fc0d4840463a4b180550bc3f5883"

  project_id   = data.azuredevops_project.infrastructure.id
  name         = "terraform-oci-bootstrap"
  description  = "Credenciais e configuracao da pipeline de bootstrap do state OCI"
  allow_access = true

  variables = {
    AZDO_ORG_SERVICE_URL         = var.org_service_url
    OCI_REGION                   = var.oci_region
    OCI_OBJECT_STORAGE_NAMESPACE = var.oci_object_storage_namespace
    OCI_TF_STATE_BUCKET          = var.oci_tf_state_bucket
    OCI_TF_STATE_KEY             = "aws/cloud-aws-infra/terraform.tfstate"
    OCI_TF_STATE_MIGRATED        = "false"
  }

  secret_variables = {
    AZDO_PERSONAL_ACCESS_TOKEN = var.personal_access_token
    OCI_TENANCY_OCID           = var.oci_tenancy_ocid
    OCI_USER_OCID              = var.oci_user_ocid
    OCI_FINGERPRINT            = var.oci_fingerprint
    OCI_COMPARTMENT_ID         = var.oci_compartment_id
  }
}

module "azuredevops_environments" {
  for_each = local.environments

  source = "git::https://github.com/Edwanderson94/Terraform-Modules.git//azure_devops/environment?ref=a20519ff4a2562800930dcb121bdd150beaae05f"

  project_id  = data.azuredevops_project.infrastructure.id
  name        = each.value.name
  description = each.value.description
}

module "azuredevops_aws_variablegroup" {
  source = "git::https://github.com/Edwanderson94/Terraform-Modules.git//azure_devops/variable-groups?ref=cfc19ec6bde0fc0d4840463a4b180550bc3f5883"

  project_id   = data.azuredevops_project.infrastructure.id
  name         = "terraform-aws-cloud"
  description  = "Variaveis estruturais da pipeline AWS; preencher credenciais e state antes do plan"
  allow_access = true

  # Session tokens are optional; omit the variable for long-lived credentials.
  # Temporary credentials must provide all three values from the same session.
  variables = merge(
    {
      AWS_ACCESS_KEY_ID     = var.aws_access_key_id
      AWS_REGION            = var.aws_region
      AWS_TF_STATE_BUCKET   = var.aws_tf_state_bucket
      AWS_TF_STATE_KEY      = var.aws_tf_state_key
      AWS_TF_STATE_MIGRATED = var.aws_tf_state_migrated
    }
  )

  secret_variables = merge(
    {
      AWS_SECRET_ACCESS_KEY = var.aws_secret_access_key
    },
    try(trimspace(var.aws_session_token), "") == "" ? {} : {
      AWS_SESSION_TOKEN = var.aws_session_token
    }
  )
}
