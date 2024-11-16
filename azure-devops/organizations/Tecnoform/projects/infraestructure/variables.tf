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

variable "repositories" {
  description = "Lista de repositórios com suas configurações"
  type = list(object({
    name           = string
    default_branch = string
  }))
  default = [
    {
      name           = "repo-01"
      default_branch = "main"
    },
    {
      name           = "repo-02"
      default_branch = "develop"
    },
    {
      name           = "repo-03"
      default_branch = "develop"
    },
    {
      name           = "repo-04"
      default_branch = "develop"
    },
    {
      name           = "repo-05"
      default_branch = "develop"
    }
  ]
}