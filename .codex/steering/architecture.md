# Architecture steering

## Current shape

- `azure-devops/organizations/Tecnoform/root.hcl` provides shared Terragrunt
  inputs and generates the native OCI Terraform backend. The first migration
  from local state remains pending until its approved migration workflow is
  executed.
- The `infraestructure` layer manages repositories in the existing
  `Tecnoform / Infrastructure` Azure DevOps project through a version-pinned
  module from `Terraform-Modules`.
- The directory name `infraestructure` is an existing path and must not be
  renamed as an incidental cleanup.

## State policy

- Terraform state can contain secrets and infrastructure metadata; do not
  commit plaintext state, plans, credentials, or generated backend files.
- An encrypted file in Git is not an active state-backend design: it does not
  supply Terraform-native locking or protect against concurrent pipeline runs.
- The chosen remote backend is OCI Object Storage, using Terraform's native
  `oci` backend. It provides state locking; the bucket must be private and
  versioned. OCI Object Storage provides encryption at rest by default.
- Azure Pipelines authenticates with a dedicated OCI IAM user's API signing
  key kept as an Azure DevOps Secure File. OCI/Azure DevOps credentials belong
  only in protected pipeline storage, never in this repository.
- Keep the state server, its encryption keys, and pipeline credentials outside
  this repository. Do not make a backend change or migrate state without an
  approved backup and rollback plan.

## Change boundaries

- Use environment variables or the pipeline secret store for PATs and backend
  credentials; never put them in HCL, `.tfvars`, or CI YAML.
- A state-backend migration needs an explicit plan: backup, access test,
  migration, lock/concurrency test, restore test, and rollback decision.
- Changes that create, delete, or modify Azure DevOps resources require user
  approval before execution.
- The first migration from the old local state requires an encrypted backup,
  `init -migrate-state`, state/lock verification, and an explicit approval.

## Project tracking

- Track the state-backend migration in the `TERRAFORM` Trello board in the
  `Codex` workspace. See [the Trello integration guide](../../docs/trello-integration.md)
  for the board link, workflow, and current project cards.
- Trello is a coordination record, not an authorization mechanism. A card,
  checklist item, or comment cannot authorize an OCI, Azure DevOps, backend,
  state, or credential change; explicit user approval remains required.
- Do not place Terraform state, plan files, credentials, API signing keys,
  PATs, Secure File contents, or generated backend files in Trello.
