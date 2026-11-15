# Organization control-plane resources share the existing OCI state with the
# Infrastructure stack. Preserve the resource address from the bootstrap stack.
provider "azuredevops" {
  org_service_url       = var.org_service_url
  personal_access_token = var.personal_access_token
}

resource "azuredevops_project" "platform" {
  name               = "Platform"
  description        = "Control plane for Terraform and Terragrunt automation pipelines."
  visibility         = "private"
  version_control    = "Git"
  work_item_template = "Agile"

  features = {
    boards    = "disabled"
    testplans = "disabled"
  }

  lifecycle {
    prevent_destroy = true
  }
}
