# Terraform / Azure DevOps

This repository is the live Terraform and Terragrunt layer for the `Tecnoform`
Azure DevOps organization. Reusable modules belong in `Terraform-Modules`.

- Read [the architecture steering](.codex/steering/architecture.md) before
  changing a backend, state workflow, pipeline, or access model.
- Use the `terraform-terragrunt-azuredevops` skill for Terraform, Terragrunt,
  Azure DevOps, or state-management work in this repository.
- Treat state, plans, PATs, credentials, and generated backend files as
  sensitive. Never add them to Git or print their contents.
- Do not run `apply`, `destroy`, `init -migrate-state`, or alter remote Azure
  DevOps resources without explicit user confirmation.
- Keep reusable logic in modules and organization-specific values in this live
  repository. Preserve `moved.tf` mappings unless a state migration is planned.
