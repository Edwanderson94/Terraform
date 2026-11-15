locals {
  org_service_url       = get_env("AZDO_ORG_SERVICE_URL", "https://dev.azure.com/Tecnoform")
  personal_access_token = get_env("AZDO_PERSONAL_ACCESS_TOKEN")
  oci_namespace         = get_env("OCI_OBJECT_STORAGE_NAMESPACE")
  oci_state_bucket      = get_env("OCI_TF_STATE_BUCKET")
}

# The bucket is provisioned separately by terraform-state. Credentials are
# intentionally omitted from the generated backend and supplied at runtime.
generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    terraform {
      backend "oci" {
        auth      = "APIKey"
        bucket    = "${local.oci_state_bucket}"
        namespace = "${local.oci_namespace}"
        key       = "${path_relative_to_include()}/terraform.tfstate"
      }
    }
  EOF
}

inputs = {
  org_service_url       = local.org_service_url
  personal_access_token = local.personal_access_token
}
