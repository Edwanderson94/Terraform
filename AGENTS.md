# Terraform / Azure DevOps

This is the live Terraform and Terragrunt layer for the Tecnoform Azure DevOps
organization. Reusable modules belong in `Terraform-Modules`.

## Local guidance

- Read `.codex/steering/architecture.md` for state, backend, pipeline, or access-model
  changes.
- Use `.codex/skills/terraform-terragrunt-azuredevops/SKILL.md` for Terraform,
  Terragrunt, Azure DevOps, pipeline, or state-management work.
- Use `.codex/skills/gitflow-azure-devops/SKILL.md` for branches, releases, pull
  requests, and tags.
- Synchronize all repository work with Trello according to the global policy. Use
  `.codex/steering/trello-integration.md` for the Terraform-specific board and
  workflow specialization.

## Boundaries

- Treat state, plans, PATs, credentials, generated backend files, and pipeline secrets
  as sensitive. Never commit or print them.
- Do not run `apply`, `destroy`, `init -migrate-state`, or alter remote Azure DevOps
  resources without explicit user confirmation.
- Keep reusable logic in modules and organization-specific values in this live
  repository.
- Preserve `moved.tf` mappings and existing user changes.

## Verification

Use the repository's documented checks: `terraform fmt`, `terragrunt hcl fmt`,
`terragrunt validate`, and `terragrunt plan` when appropriate and safe.

## Source of truth

This root file is the repository's authoritative agent guidance. The legacy
`.codex/AGENTS.md` is retained only as a compatibility pointer for existing local
skills and should not contain additional rules.
