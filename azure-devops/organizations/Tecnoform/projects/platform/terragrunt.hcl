# Temporary bootstrap layer for the Azure DevOps Platform project.
#
# It intentionally does not include the organization root: the shared root
# generates the OCI backend, which cannot be used until the state bucket has
# been provisioned. Terraform therefore keeps this layer's local state beside
# this file. The state is ignored by Git and must be migrated to OCI through
# the approved migration workflow after the backend bootstrap succeeds.
locals {
  org_service_url       = get_env("AZDO_ORG_SERVICE_URL", "https://dev.azure.com/Tecnoform")
  personal_access_token = get_env("AZDO_PERSONAL_ACCESS_TOKEN")
}

inputs = {
  org_service_url       = local.org_service_url
  personal_access_token = local.personal_access_token
  project_name          = "Platform"
}
