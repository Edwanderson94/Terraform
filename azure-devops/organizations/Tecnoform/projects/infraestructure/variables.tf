# ================================================================
# Variables
# ================================================================

variable "org_service_url" {
  description = "URL da organizacao no Azure DevOps"
  type        = string
}

variable "personal_access_token" {
  description = "PAT de acesso a organizacao no Azure DevOps"
  type        = string
  sensitive   = true
}

variable "project_name" {
  description = "Nome do projeto no Azure DevOps"
  type        = string
}

variable "repositories" {
  description = "Mapa de repositorios gerenciados"
  type = map(object({
    name           = string
    default_branch = string
  }))
}

variable "repository_branches" {
  description = "Branches que devem existir em todos os repositorios gerenciados"
  type        = list(string)
  default     = ["develop", "homolog", "master"]
}

variable "repository_branch_renames" {
  description = "Mapa por repositorio para renomear branches. Exemplo: { aws = { main = \"master\" } }"
  type        = map(map(string))
  default     = {}
}

variable "repository_branches_to_delete" {
  description = "Mapa por repositorio com branches que devem ser removidas"
  type        = map(list(string))
  default     = {}
}
