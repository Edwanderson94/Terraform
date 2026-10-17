---
name: terraform-terragrunt-azuredevops
description: "Review or change the Terraform and Terragrunt Azure DevOps live stack, including backend and state-management work."
---

# Terraform, Terragrunt, and Azure DevOps

Use this skill when working on the Terraform/Terragrunt configuration, Azure
DevOps resources, pipeline automation, or the Terraform state design in this
repository.

## Repository context

- Read `AGENTS.md` first. Read `.codex/steering/architecture.md` when the task
  affects state, backends, credentials, pipelines, or access.
- Use [the Trello integration guide](../../../docs/trello-integration.md) when
  planning, creating, or updating project-tracking work for the Terraform
  state migration. Keep the board aligned with the approved migration stages;
  a Trello card never authorizes a backend migration, remote change, or access
  change on its own.
- `root.hcl` is shared organization configuration; project-level
  `terragrunt.hcl` files should contain only layer-specific inputs.
- The current `infraestructure` layer manages repositories for an existing
  project. It does not create the organization or the project.
- The reusable repository module is remote and version-pinned. Do not change a
  module version without reviewing its compatibility and resulting plan.

## State and secrets

- Never use Git, including a Git repository with an encrypted state file, as
  the active Terraform backend. Require a backend with locking before pipeline
  automation.
- Prefer a self-hosted remote backend when the user requires no cloud cost.
  Evaluate availability, locking, backup/restore, encryption at rest, TLS,
  network reachability from a self-hosted agent, and least-privilege access.
- Keep credentials out of repository files and command output. Use environment
  variables or the CI secret store.

## Safe workflow

1. Inspect the applicable HCL, state configuration, module contract, and Git
   status before proposing changes.
2. For HCL changes, run formatting and validation that do not modify remote
   resources when the required tooling and credentials are available.
3. Present migration, `apply`, `destroy`, or remote-resource changes for
   confirmation before executing them. Include backup and rollback details for
   every state migration.

## Trello project tracking

- The state-migration work is tracked in the `TERRAFORM` board in the `Codex`
  Trello workspace. The board has `Backlog`, `Em execução`, and `Finalizado`
  lists.
- Create or move cards only to reflect agreed work. Keep sensitive state,
  plans, credentials, API keys, PATs, and Secure File contents out of card
  titles, descriptions, comments, and attachments.
- Put preparation, design, and approval work in `Backlog`; move a card to
  `Em execução` only when the work has started; move it to `Finalizado` only
  after its validation is complete. The migration card remains blocked until
  the backup, rollback plan, and explicit user approval are recorded.
- Whenever work is associated with a card, create or maintain a checklist.
  Add the material steps before or as the work starts, mark each completed
  step promptly, and retain an unchecked item that names any blocker and its
  required dependency. Do not put secrets or state-derived data in checklist
  items.
- Apply exactly one status label to every project card and update it as the
  card changes: green for completed, yellow for pending, and red for blocked.
