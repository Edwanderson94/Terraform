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
