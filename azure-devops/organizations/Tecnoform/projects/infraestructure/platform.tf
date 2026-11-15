# Organization control-plane resources share the existing OCI state with the
# Infrastructure stack. Preserve the resource address from the bootstrap stack.
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
