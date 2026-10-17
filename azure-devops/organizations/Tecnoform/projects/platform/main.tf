# ================================================================
# Azure DevOps - Platform project
# ================================================================

resource "azuredevops_project" "platform" {
  name               = var.project_name
  description        = "Control plane for Terraform and Terragrunt automation pipelines."
  visibility         = "private"
  version_control    = "Git"
  work_item_template = "Agile"
}
