output "project_id" {
  description = "ID do projeto Azure DevOps Platform"
  value       = azuredevops_project.platform.id
}

output "project_name" {
  description = "Nome do projeto Azure DevOps Platform"
  value       = azuredevops_project.platform.name
}

output "project_url" {
  description = "URL do projeto Azure DevOps Platform"
  value       = "${trimsuffix(var.org_service_url, "/")}/${azuredevops_project.platform.name}"
}
