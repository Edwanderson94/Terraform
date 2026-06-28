# Configuração do estado remoto
remote_state {
  backend = "local"
  config = {
    path = "${get_terragrunt_dir()}/terraform.tfstate"
  }
}

# Configuração do Terraform para o módulo
terraform {
  source = "git::https://github.com/Edwanderson94/Terraform-Modules.git//azure_devops/terraform-azuredevops-repositorios?ref=develop"
}

inputs = {
  org_service_url       = "https://dev.azure.com/Tecnoform"
  personal_access_token = "AtBa9kYmm51iuf7Yc1w0cJtJEB3EJgbbiDWbKm4aVppixyLM9jHyJQQJ99CFACAAAAAAAAAAAAASAZDO1PJb"
}
