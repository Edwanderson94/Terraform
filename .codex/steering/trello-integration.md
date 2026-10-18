# Trello integration

This repository uses Trello to track the Terraform state migration to OCI
Object Storage. Trello provides work visibility only; it is not a source of
credentials and it does not approve infrastructure changes.

## Workspace and boards

The relevant Trello workspace is **Codex**. Its project boards are:

| Board | Purpose | Link |
| --- | --- | --- |
| TERRAFORM | Remote Terraform state migration and its operational follow-up | [Open board](https://trello.com/b/98CQinb0/terraform-state-na-cloud) |
| Automacao Trello | Trello automation backlog | [Open board](https://trello.com/b/macIarM5/automacao-trello) |
| pyGmailAutomate | Gmail automation roadmap, operations, and pending work | [Open board](https://trello.com/b/BXznDuYS/pygmailautomate) |

The Terraform board was initially created with the name `Terraform State na
Cloud`; its intended display name is `TERRAFORM`.

## Board workflow

The `TERRAFORM` board uses three lists:

| List | Use |
| --- | --- |
| Backlog | Approved or proposed work that has not started. |
| Em execução | Work actively in progress. |
| Finalizado | Work whose acceptance criteria and validation are complete. |

Cards currently cover the migration lifecycle: inventory of the local state,
OCI backend design and provisioning, pipeline identity and secrets,
connectivity and permission validation, migration and rollback planning,
explicit migration approval, the migration itself, and state/lock/recovery
validation.

## Checklists

Every card that has active or completed work must have a checklist that
records its material steps. Mark a step complete as soon as it is verified.
When work cannot continue, leave a clearly worded unchecked step explaining
the blocker and the dependency needed to remove it. Update the checklist when
the work resumes or the blocker changes.

Checklists are operational summaries only: they must never contain state
contents, plan output, credentials, identifiers that are sensitive in context,
or Secure File material.

## Status labels

Every card has one visual status label, independent of its list position:

| Label color | Meaning |
| --- | --- |
| Green | Completed and validated. |
| Yellow | Pending work that has not started. |
| Red | Blocked; the checklist identifies the dependency to resolve. |

Update the label whenever the task state changes. A card in `Em execução` may
be red when active work has reached a blocker.

## Planned work-category labels

The following mapping is approved for a later Trello label-renaming pass. It
is not yet applied in Trello because the connected integration currently does
not support label creation or renaming:

| Label color | Planned name |
| --- | --- |
| Green | Infraestrutura OCI |
| Yellow | Pendência / Decisão |
| Orange | Migração & Rollback |
| Red | Segurança & Acessos |
| Purple | Terraform State & Backend |
| Blue | CI/CD & Automação |

When these category labels are applied, use the board list and card checklist
as the authoritative representation of task status.

## Safety rules

- Never add Terraform state, plans, credentials, PATs, OCI API signing keys,
  Secure File contents, or generated backend files to a Trello card, comment,
  checklist, or attachment.
- A Trello card does not authorize a remote change. Creating OCI resources,
  changing Azure DevOps settings, modifying a backend, or running
  `init -migrate-state` requires explicit user approval.
- Before the migration card can move to `Em execução`, confirm an encrypted
  backup, access test, lock/concurrency test plan, restore test, and rollback
  decision.
- Move a card to `Finalizado` only after the planned validation is complete.
