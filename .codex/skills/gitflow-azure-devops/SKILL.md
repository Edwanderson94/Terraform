---
name: gitflow-azure-devops
description: "Manage Gitflow branches, releases, pull requests, and version tags for Tecnoform Azure DevOps repositories. Use when creating or moving feature, fix, docs, release, hotfix, or production branches."
---

# Gitflow for Tecnoform Azure DevOps

Use this skill for Git branch and release work in the Tecnoform Azure DevOps
repositories. Determine the repository root with `git rev-parse --show-toplevel`
before changing branches or files.

## Branch model

- `master` is production. Do not push directly to it.
- Do not use a persistent `develop` branch as an integration branch.
- Create `release/<major>.<minor>.<patch>` from `master`. A release branch is
  the integration branch for exactly that version.
- Use `feature/<short-description>` for new capabilities, based on its target
  `release/<version>` branch.
- Use `fix/<short-description>` for non-production bug fixes, based on its
  target `release/<version>` branch.
- Use `docs/<short-description>` for documentation-only changes, based on its
  target `release/<version>` branch.
- Use `hotfix/<short-description>` only for urgent production fixes, based on
  `master`.

Merge `feature/`, `fix/`, and `docs/` branches into their target release.
Merge a completed release into `master`, then tag that production commit as
`v<major>.<minor>.<patch>`. The next release begins from the resulting
`master`. Merge a hotfix directly into `master` and tag it with the next patch
version; incorporate it into an open release only when that release requires
the fix.

## Safe workflow

1. Inspect `git status --short --branch`, remotes, available branches, and
   applicable branch policies before creating or pushing a branch.
2. Preserve unrelated local changes. Never use a destructive reset or checkout
   to make a branch switch succeed.
3. Create a branch from its required base and set its upstream only after the
   remote push succeeds.
4. Use a pull request to integrate a work branch into its release, and a
   separate pull request to promote a release into `master`, respecting Azure
   DevOps branch policies even when no policy is currently configured.
5. Treat remote pushes, pull-request completion, tags, and branch deletion as
   external mutations: obtain explicit authorization immediately before those
   actions unless it was explicitly requested in the current task.

## Terraform repositories

Never commit Terraform state, plans, credentials, generated backend files, or
`.tfvars` containing secrets. For state/backend, Azure DevOps pipeline, or
access-model changes, also use the `terraform-terragrunt-azuredevops` skill.
