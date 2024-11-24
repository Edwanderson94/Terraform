include {
  path = find_in_parent_folders()
}

inputs = {
  project_name = "Infrastructure"
  repositories = {
    "repo-01" = {
      name           = "repo-01"
      default_branch = "main"
    },
    "repo-02" = {
      name           = "repo-02"
      default_branch = "dev"
    },
    "repo-03" = {
      name           = "repo-03"
      default_branch = "uat"
    }
  }
}
