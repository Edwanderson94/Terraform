---
name: terraform-pipeline-integration
description: Integrate the Tecnoform reusable Azure Pipelines template into a Terraform and Terragrunt infrastructure repository using OCI Object Storage for state. Use when adding or adapting an Azure pipeline to consume patter-pipeline-terraform; not for managing Azure DevOps accounts or changing live infrastructure.
---

# Terraform pipeline integration

Set up or update a consumer repository to use the pipeline template in this
repository. Read the root `README.md` and `templates/terraform-terragrunt.yml`
before editing; treat those files as the source of truth for parameter names
and pipeline behavior.

## Integration workflow

1. Inspect the consumer repository's Terraform/Terragrunt layout, branch names,
   existing Azure Pipelines configuration, and backend configuration.
2. Add or adapt `azure-pipelines.yml` to reference this repository as an Azure
   Pipelines repository resource and use `extends` with
   `templates/terraform-terragrunt.yml`.
3. Set `workingDirectory` to the directory containing that stack's
   `terragrunt.hcl`. Set `variableGroup`, `secureFile`, and `environment` to
   resources provisioned for that consumer. Keep `stateMigratedVariable` false
   or unset until the OCI state migration is completed and verified.
4. Configure triggers and PR targets for the consumer's branches. The Tecnoform
   convention is `develop`, `homolog`, and `master`, with `master` as default.
   Preserve a repository's explicitly requested branch model when it differs.
5. Explain the required Azure DevOps variable group, Secure File, repository
   authorization, and Environment checks to the user. YAML cannot create these
   protected resources itself.
6. Review the diff and validate YAML syntax using available local tooling. Do
   not run Terraform apply or change remote Azure/OCI resources as part of
   ordinary pipeline integration.

## Template behavior and invariants

- PRs and pushes run formatting and validation. The template's plan and apply
  stages run only for non-PR pushes to `master` after the configured state
  migration variable equals `true`.
- Apply uses the plan artifact produced by the preceding stage and runs under
  the configured Azure DevOps Environment. Approval and exclusive locking must
  be configured on that Environment in Azure DevOps.
- The named variable group must provide `AZDO_PERSONAL_ACCESS_TOKEN`,
  `AZDO_ORG_SERVICE_URL`, `OCI_TENANCY_OCID`, `OCI_USER_OCID`,
  `OCI_FINGERPRINT`, `OCI_REGION`, `OCI_OBJECT_STORAGE_NAMESPACE`,
  `OCI_TF_STATE_BUCKET`, and the state migration flag. Store credentials as
  secret variables where appropriate.
- The Secure File must contain the OCI API signing private key. Never put the
  key, Terraform state, `.terraform` directory, generated backend config, or
  plan contents in source control. Plan artifacts may contain sensitive values;
  restrict pipeline access and retention.
- The shared template exports OCI provider environment variables once using
  the canonical uppercase names (`OCI_TENANCY_OCID`, `OCI_USER_OCID`,
  `OCI_FINGERPRINT`, `OCI_REGION`, and `OCI_PRIVATE_KEY_PATH`). Do not add
  aliases that differ only by letter case in a single Azure Pipelines `env`
  mapping; those names collide.
- Keep Terraform and Terragrunt versions pinned through template parameters.
  Change them only when the consumer has been checked against the selected
  versions.

## Consumer reference

Use the example in the root `README.md` as the starting point. If the consumer
repository needs the same skill for future agent work, copy this skill folder
into its `.agents/skills/` directory and adjust only repository-specific
references.
