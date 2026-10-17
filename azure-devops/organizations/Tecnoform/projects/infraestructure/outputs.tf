output "terraform_state_bootstrap_pipeline_id" {
  description = "ID da pipeline Terraform/Terragrunt de bootstrap OCI no projeto Infrastructure."
  value       = module.terraform_state_bootstrap_pipeline.id
}

output "terraform_state_bootstrap_pipeline_name" {
  description = "Nome da pipeline Terraform/Terragrunt de bootstrap OCI."
  value       = module.terraform_state_bootstrap_pipeline.name
}
