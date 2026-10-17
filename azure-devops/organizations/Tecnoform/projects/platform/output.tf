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
  value       = azuredevops_project.platform.url
}
