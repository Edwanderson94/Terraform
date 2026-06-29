# Includes the shared Terragrunt configuration for the Tecnoform organization.
include {
  path = find_in_parent_folders("root.hcl")
}

inputs = {
  project_name = "Infrastructure"
}
