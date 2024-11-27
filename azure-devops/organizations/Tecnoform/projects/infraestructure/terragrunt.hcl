# Bloco terraform com o source do módulo
terraform {
  source = "git::https://github.com/Edwanderson94/Terraform-Modules.git//terraform-azdo-modules/azuredevops_repository?ref=develop"
}

# Configuração do provider Azure DevOps
provider "azuredevops" {
  org_service_url       = ""
  personal_access_token = ""
}

# Inclui o arquivo terragrunt.hcl do diretório pai
include {
  path = find_in_parent_folders()
}

# Definindo as entradas para o projeto
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



