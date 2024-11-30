# Inclui o arquivo terragrunt.hcl do diretório pai
include {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://github.com/Edwanderson94/Terraform-Modules.git//terraform-azdo-modules/azuredevops_repository?ref=develop"
}

inputs = {
  project_name          = "Infrastructure"
  org_service_url       = "https://dev.azure.com/Tecnoform"
  personal_access_token = "4gZ0nh5lzRrRzp1heC6JxnWDHyypbyPmpCY2X4rFI8LGpqzgytK7JQQJ99AKACAAAAAAAAAAAAASAZDOQC1x"

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