locals {
  org_service_url       = get_env("AZDO_ORG_SERVICE_URL", "https://dev.azure.com/Tecnoform")
  personal_access_token = get_env("AZDO_PERSONAL_ACCESS_TOKEN")
}

# State remains local until the OCI state bucket is provisioned. Do not add a
# remote_state block here before the bucket and migration procedure are ready.

inputs = {
  org_service_url       = local.org_service_url
  personal_access_token = local.personal_access_token
}
