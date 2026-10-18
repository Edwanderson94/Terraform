---
name: terraform-pipeline-integration
description: Integrate the Tecnoform reusable Azure Pipelines template into the Terraform repository or an explicitly identified Tecnoform consumer. Use only for Azure Pipelines changes involving patter-pipeline-terraform, Terragrunt, and OCI Terraform state.
---

# Terraform pipeline integration

Use this skill only for the Tecnoform Terraform/Terragrunt pipeline workflow. It is
repository-scoped and must not be applied to unrelated application repositories.

Set up or update a consumer repository to use the pipeline template in this
repository. Read the consumer root `README.md` and locate the actual template source
before editing; do not assume `templates/terraform-terragrunt.yml` exists in every
checkout. If the template source is unavailable, stop before editing and report the
missing dependency.

## Integration workflow

1. Inspect the consumer repository's Terraform/Terragrunt layout, branch names,
   existing Azure Pipelines configuration, and backend configuration.
2. Add or adapt `azure-pipelines.yml` to reference this repository as an Azure
   Pipelines repository resource and use `extends` with
   `templates/terraform-terragrunt.yml`.
3. Set `workingDirectory` to the directory containing that stack's `terragrunt.hcl`.
   Set `variableGroup`, `secureFile`, and `environment` to resources provisioned for
   that consumer. Keep `stateMigratedVariable` false or unset until OCI state
   migration is completed and verified.
4. Configure triggers and PR targets for the consumer's branches. The Tecnoform
   convention is `develop`, `homolog`, and `master`, with `master` as default.
   Preserve a repository's explicitly requested branch model when it differs.
5. Explain the required Azure DevOps variable group, Secure File, repository
   authorization, and Environment checks. YAML cannot create these protected
   resources itself.
6. Review the diff and validate YAML syntax using available local tooling. Do not run
   Terraform apply or change remote Azure/OCI resources as part of ordinary pipeline
   integration.

## Template behavior and invariants

- PRs and pushes run formatting and validation. Plan and apply run only for non-PR
  pushes to `master` after the configured state migration variable equals `true`.
- Apply uses the plan artifact produced by the preceding stage and runs under the
  configured Azure DevOps Environment. Approval and exclusive locking must be
  configured on that Environment.
- The variable group must provide the required Azure DevOps, OCI, and state migration
  settings, with credentials stored as secrets where appropriate.
- The Secure File contains the OCI API signing private key. Never put the key,
  Terraform state, `.terraform` directory, generated backend config, or plan contents
  in source control.
- Keep Terraform and Terragrunt versions pinned through template parameters.

## Safety

A pipeline card does not authorize remote changes. Require explicit approval before
apply, destroy, backend migration, or changes to protected Azure DevOps resources.
