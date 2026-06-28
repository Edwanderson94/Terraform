locals {
  org_service_url       = get_env("AZDO_ORG_SERVICE_URL", "https://dev.azure.com/Tecnoform")
  personal_access_token = get_env("AZDO_PERSONAL_ACCESS_TOKEN")
  terraform_state_path  = get_env("TG_TF_STATE_PATH", "${get_terragrunt_dir()}/terraform.tfstate")
}

# State configuration.
# The current backend is local for workstation runs. In CI/CD, either persist this
# state path between stages or replace this block with a shared remote backend.
remote_state {
  backend = "local"
  config = {
    path = local.terraform_state_path
  }
}

inputs = {
  org_service_url       = local.org_service_url
  personal_access_token = local.personal_access_token
}
