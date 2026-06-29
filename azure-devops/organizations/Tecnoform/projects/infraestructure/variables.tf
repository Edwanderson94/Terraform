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

