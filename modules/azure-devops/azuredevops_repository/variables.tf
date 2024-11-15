# ================================================================
# Variables
# ================================================================

variable "org_service_url" {
  type = string
}

variable "personal_access_token" {
  type      = string
  sensitive = true
}

variable "project_id" {
  type = string
}

variable "repository_name" {
  type = string
}

variable "default_branch" {
  type    = string
  default = "master"
}
