resource "azuredevops_git_repository" "cloud_azure_tf" {
  project_id     = azuredevops_project.project_infra.id
  name           = "Cloud-Azure-TF"
  default_branch = "refs/heads/master"
  initialization {
    init_type = "Clean"
  }
}