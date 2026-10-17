locals {
  org_service_url       = get_env("AZDO_ORG_SERVICE_URL", "https://dev.azure.com/Tecnoform")
  personal_access_token = get_env("AZDO_PERSONAL_ACCESS_TOKEN")
  oci_state_bucket      = get_env("OCI_TF_STATE_BUCKET")
  oci_state_namespace   = get_env("OCI_OBJECT_STORAGE_NAMESPACE")
}

# OCI Object Storage supplies a shared state backend with Terraform-native
# locking. Credentials are deliberately read from the OCI_* environment
# variables, never from this repository or from a backend configuration file.
remote_state {
  backend = "oci"

  config = {
    bucket               = local.oci_state_bucket
    namespace            = local.oci_state_namespace
    key                  = "${path_relative_to_include()}/terraform.tfstate"
    workspace_key_prefix = "workspaces"
    auth                 = "APIKey"
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

inputs = {
  org_service_url       = local.org_service_url
  personal_access_token = local.personal_access_token
}
