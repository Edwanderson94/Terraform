# ======================================================
# Variables
# ======================================================

variable "org_service_url" {
  description = "URL da sua organization no Azure DevOps"
  type        = string
}

variable "personal_access_token" {
  description = "PAT de acesso a sua organization no Azure DevOps"
  type        = string
  sensitive   = true
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "repositories" {
  description = "Mapa de repositórios a serem criados. A chave do mapa deve ser um identificador lógico estável e o valor define o nome do repositório e branch padrão"
  type = map(object({
    name           = string
    default_branch = string
  }))
}
