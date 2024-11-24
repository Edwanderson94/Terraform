# Configuração do estado remoto
remote_state {
  backend = "local"
  config = {
    path = "${get_terragrunt_dir()}/terraform.tfstate"
  }
}

# Configuração do Terraform para o módulo
terraform {
  source = "git::https://github.com/Edwanderson94/Terraform-Modules.git//terraform-azdo-modules/azuredevops_repository?ref=develop"
}

inputs = {
  org_service_url       = "https://dev.azure.com/Tecnoform"
  personal_access_token = "yd7oeczyfwhms7epd5eu6uoir4clxqensvbuiuqat3zupldtopvq"
}