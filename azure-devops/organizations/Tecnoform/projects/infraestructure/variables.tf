# ======================================================
# Variables
# ======================================================

variable "org_service_url" {
  type    = string
  default = "https://dev.azure.com/Tecnoform"
}

variable "personal_access_token" {
  type      = string
  sensitive = true
  default   = "yd7oeczyfwhms7epd5eu6uoir4clxqensvbuiuqat3zupldtopvq"
}

variable "repository_name" {
  description = "Nome do repositório no Azure DevOps"
  type        = string
  default     = "example-repo-module"
}

variable "default_branch" {
  description = "Nome do branch padrão do repositório"
  type        = string
  default     = "master"
}
