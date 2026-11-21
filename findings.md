# Findings & Decisions

## Requirements
- Acompanhar a estrutura Terraform/Terragrunt e a integração Azure DevOps.
- Diferenciar o backend do control-plane Terraform do state do repositório `terraform-state`.
- Registrar controles de pipeline, permissões, evidências de execução e pendências sem incluir secrets.

## Research Findings
- Entrada Terragrunt do control-plane: `azure-devops/organizations/Tecnoform/projects/infraestructure/terragrunt.hcl`.
- Configuração compartilhada: `azure-devops/organizations/Tecnoform/root.hcl` gera `backend.tf` com backend OCI e usa `path_relative_to_include()` para a chave.
- Projetos gerenciados no control-plane: `infraestructure` e `platform`; o nome `infraestructure` é legado e não deve ser renomeado incidentalmente.
- Módulos reutilizáveis são consumidos de `Terraform-Modules` por referências versionadas/commitadas.
- Pipeline separada do bootstrap: repositório `terraform-state`, pipeline 67 `Terraform State Cloud OCI`, Environment 12 `terraform-oci-bootstrap`.
- A pipeline de bootstrap usa o template cross-project `Platform/patter-pipeline-terraform` e o Secure File `oci-terraform-api-key.pem`; o conteúdo da chave não deve ser documentado.
- A pipeline deve executar Validate, Plan e Apply usando o plano publicado; Apply é protegido pelo Environment.
- O state do repositório `terraform-state` continua local até uma migração aprovada; não executar `init -migrate-state` automaticamente.
- O Environment OCI possui Approval ID 22 e ExclusiveLock ID 23; a pipeline 67 está autorizada.
- O repositório `terraform-state` possui política bloqueante de mínimo 1 revisor em `refs/heads/master` (ID 1).
- O acesso cross-project da pipeline 67 ao repositório `Platform/patter-pipeline-terraform` foi autorizado.
- Branch Control foi testado, mas removido do Environment porque falhou ao avaliar a referência cross-project por SHA; a proteção de `master` permanece pela política do repositório.
- Execução 1996 comprovou o comportamento desejado até o ponto de approval: plan passou e a stage Apply ficou aguardando aprovação.

## Technical Decisions
| Decision | Rationale |
|----------|-----------|
| Não versionar state, plan, PAT ou chaves | Reduz risco de exposição de credenciais e metadados de infraestrutura. |
| Registrar IDs e nomes de recursos, não valores secretos | Permite auditoria sem copiar credenciais ou payloads sensíveis. |
| Tratar aprovação runtime como pendência separada da configuração | Configuração via API prova o check; execução aprovada prova o caminho operacional. |
| Manter o template cross-project pinado enquanto não houver decisão de atualização | A referência por commit melhora reprodutibilidade, mas interfere na avaliação de Branch Control. |
| Modelar os guardrails como bloco opcional `controls` no módulo de pipelines | Permite compatibilidade com consumidores atuais e habilitação gradual por pipeline. |
| O módulo deve controlar Environment, approval, exclusive lock e pipeline authorization | Esses recursos protegem a execução da pipeline e têm relação direta com o pipeline ID. |
| Branch policies devem permanecer em módulo separado ou no módulo de repositórios | Elas governam pull requests e branches, não o ciclo de execução da pipeline. |

## Proposed Reusable Module Contract

O módulo `azure_devops/pipelines` pode receber um bloco opcional conceitualmente semelhante a:

```hcl
controls = {
  enabled = true

  environment = {
    name        = "terraform-oci-bootstrap"
    description = "Protected Terraform apply environment"
    create      = false
  }

  approval = {
    enabled                    = true
    approver_ids               = []
    minimum_required_approvers = 1
    requester_can_approve      = false
    timeout                    = 1440
    instructions               = "Review the Terraform plan before approval."
  }

  exclusive_lock = {
    enabled = true
    timeout = 43200
  }

  authorizations = [
    # environment, repository, variable group or other supported resources
  ]
}
```

O contrato real deve evitar PATs, Secure Files, state ou conteúdo de chaves. IDs
de projetos, pipeline, ambiente, repositórios e grupos podem ser obtidos por data
sources ou passados como entradas explícitas.

## Scope Boundary

- Dentro do módulo de pipelines: `azuredevops_environment`, approval check,
  exclusive lock e `azuredevops_pipeline_authorization`.
- Fora do módulo de pipelines: `azuredevops_branch_policy_min_reviewers` e demais
  políticas de PR/branch, preferencialmente no módulo de repositórios.
- Branch Control deve ser opcional e só habilitado após resolver o problema já
  observado com template cross-project referenciado por SHA.
- Secure Files permanecem fora do state Terraform até existir uma estratégia segura
  que não grave material sensível no state.

## Migration Constraint

Os controles já criados via API não devem ser recriados automaticamente. O módulo
deve prever uma fase de importação/reconciliação. Environment, approval e branch
policy possuem caminho de import documentado; exclusive lock tem limitação de
importação no provider e exige uma decisão operacional específica antes de ser
gerenciado pelo módulo.

## Issues Encountered
| Issue | Resolution |
|-------|------------|
| Extensão local do Azure DevOps falhou ao usar API preview | REST API foi usada apenas para leitura/configuração necessária, sem expor PAT. |
| Branch Control bloqueou execução por recurso externo referenciado por SHA | Check removido após diagnóstico; política de proteção do branch local preservada. |

## Resources
- [README do repositório](README.md)
- [Architecture steering](.codex/steering/architecture.md)
- [Pipeline YAML local](azure-pipelines.yml)
- [Entrada Terragrunt do Azure DevOps](azure-devops/organizations/Tecnoform/projects/infraestructure/terragrunt.hcl)
- [Configuração compartilhada de backend](azure-devops/organizations/Tecnoform/root.hcl)
- [Documentação de state Azure DevOps](docs/unified-azuredevops-state.md)

## Azure DevOps Environments Adoption — 2026-11-21

### Scope and current evidence
- The exact Trello card is `Estudo e fundamentação — Azure DevOps Environments via Terraform e guardrails de aprovação`, on board `Terraform`, list `Em execução`; it is open and has no checklist.
- The consumer layer currently manages repositories, two Variable Groups, and the `Platform` project; it has no Environment module calls or Environment resources.
- The shared `azure_devops/environment` module currently manages only `azuredevops_environment.this`, with inputs `project_id`, `name`, `description`, outputs `id`, `name`, `project_id`, and fixed `prevent_destroy = true`.
- The module README documents import as `<project_id>/<environment_id>` and explicitly leaves Approvals & Checks and pipeline authorization to the consumer.
- The consumer pins provider `microsoft/azuredevops` at `1.4.0`; the module accepts `>= 1.4.0, < 2.0.0`, so the declared provider version is compatible.
- No remote discovery or Terraform state evidence has yet been collected in this continuation; no apply/import/init-migrate-state is authorized.

### Adoption decision pending discovery
- Strategy A (import existing Environments) remains the preferred path because it preserves IDs, pipeline references, permissions and checks, subject to provider import support and a no-change plan.
- Strategy B (create new Environments) must not be used if matching live Environments exist; it risks duplicate names, changed IDs, broken deployment jobs, and loss of checks/permissions.

### Remote discovery results
- Azure CLI is authenticated to organization `https://dev.azure.com/Tecnoform`; project `Infrastructure` has ID `7985f0b1-e29d-431e-babe-1e2f913f4ba7`.
- Existing Environments returned by the Azure DevOps Environments API: ID 12 `terraform-oci-bootstrap`, description `Automatically created environment`; ID 13 `terraform-aws-cloud`, description `Environment de aprovacao da pipeline AWS`.
- The `terraform-state` pipeline YAML explicitly references Environment 12. The main repository pipeline YAML references `terraform-oci-production`, which is not one of the two Environments returned for `Infrastructure`; this mismatch remains a follow-up risk and was not changed.
- Environment detail reads returned no `resources` entries in the queried payload. This is not evidence that checks, permissions, or deployment history are absent; those require separate API endpoints/queries.
- The consumer's provider is fixed at `microsoft/azuredevops` 1.4.0 and the module source is pinned to commit `a20519ff4a2562800930dcb121bdd150beaae05f`; the module's declared range includes 1.4.0.

### Consumer implementation
- Added `local.environments` with the two observed names, descriptions and IDs.
- Added `module.azuredevops_environments` with `for_each`, preserving stable logical addresses and using the shared module only.
- Added declarative imports for `project_id/12` and `project_id/13`; Terraform import was not executed.
- Added `environment_ids` output and documented that Checks, linked resources, permissions and pipeline authorizations are outside this module scope.
- No shared module files or remote Azure DevOps resources were modified.

### Checks, pipeline use and authorization evidence
- Environment 12 has Approval check ID 22 (`timeout=1440`) and ExclusiveLock check ID 23 (`timeout=43200`), both targeting `terraform-oci-bootstrap`.
- Environment 13 currently has zero check configurations from the Checks API.
- Pipeline authorization is explicit: pipeline 67 (`Terraform State Cloud OCI`) is authorized for Environment 12; pipeline 68 (`Cloud AWS Infrastructure`) is authorized for Environment 13. `allPipelines` was not enabled in either response.
- Deployment history confirms four records for Environment 12 (three succeeded and one failed, all `Apply` jobs from pipeline 67) and two successful records for Environment 13 (both `Apply` jobs from pipeline 68).
- This confirms that import adoption must preserve both Environment IDs and the existing checks/authorizations. The `azure_devops/environment` module intentionally does not manage those related objects.
- The Checks and pipeline-permission endpoints were read via the official Azure DevOps REST API with credentials already present in the shell; no write endpoint was called.

### Pipeline reference reconciliation
- The only local YAML that explicitly uses the discovered Environment 12 is `/home/edwanderson/wsl-repo/terraform-state/azure-pipelines.yml`.
- The main Terraform repository YAML and the shared pipeline template use `terraform-oci-production`, which is not present in the live `Infrastructure` Environment inventory. This is a genuine unresolved ownership/configuration mismatch, not evidence that Environment 12 should be renamed or replaced.
- The AWS pipeline references were corroborated by live deployment records for Environment 13; no change was made to pipeline YAML.

## Terraform CI/CD Warning Analysis — 2026-11-21

### Evidence scope and limitation
- Trello card: `https://trello.com/c/S8XDqvcU/16-ajustar-warning-workflow-terraform-com-gitflow` on board `Pipelines`, list `Backlog`.
- The card's current API response contains no screenshot attachment, comments, checklist or warning text; it only links to GitHub Actions run `44916605840`. The screenshot requirement could not be independently fulfilled and is explicitly treated as a limitation.
- Primary evidence was obtained from the actual workflow logs and metadata with `gh` read-only. The run was successful, and the checkout/setup/plan jobs completed successfully.

### Workflow inventory
- Workflow: `.github/workflows/terraform-azuredevops.yml` (`Terraform Azure DevOps`).
- Triggers: pull requests and pushes to `master` for `azure-devops/**`, the workflow itself and `docs/github-actions.md`; manual `workflow_dispatch` with boolean `apply`.
- Jobs: `fmt`, `validate`, `static`, `plan`, and `apply`.
- `plan` runs only on `push` or manual dispatch and uses the configured OCI backend; `apply` runs only on manual dispatch with `apply=true` and the protected GitHub Environment `terraform-azuredevops-production`.
- Actions observed: `actions/checkout@v4`, `hashicorp/setup-terraform@v3`, `actions/upload-artifact@v4`, `actions/download-artifact@v4`.
- Workflow permission: `contents: read`. Secrets and variables are referenced by name only; no values were exposed or changed.
- GitFlow references in README describe `release/<version>` as the release path and `master` as the protected publication branch. This study does not alter that process.

### Real execution evidence
- Run `44916605840`: push, branch `master`, SHA `c046c5e9d3fe0b95bbed9ac3efdc8386d88f6f1c`, 2026-11-21, conclusion `success`; `fmt`, `validate`, `static`, and `plan` succeeded; `apply` was skipped by its condition.
- Comparison runs inspected: `44916512633` (feature manual validation), `44916862120` (master manual apply), `44917001291` (master post-apply plan), and `44004401287` (earlier master dispatch). Warning patterns recur across the runs.
- Attempted read-only annotations query for run `44916605840` returned HTTP 404 through `gh`; therefore annotations are not treated as fully inventoried. Job logs are the authoritative evidence used below.

### Warning inventory and root-cause matrix

| Warning | Root cause | Severity | Recommended correction | Risk of change |
|---|---|---:|---|---:|
| Git hint: temporary checkout `git init` defaults the initial branch to `master`, with a future Git 3.0 default change | `actions/checkout` initializes a temporary local repository without an explicit `init.defaultBranch`; this is runner/tooling advice, not repository branch behavior | Low | Leave unchanged unless log cleanliness is a priority; alternatively set a scoped init default in a dedicated checkout-compatible step only after testing | Low, but unnecessary config could affect later local Git commands |
| Node `DEP0169`: ``url.parse()`` is deprecated, emitted while running `hashicorp/setup-terraform@v3` | The action or one of its bundled Node dependencies invokes the legacy Node URL API under the runner runtime | Medium | Upgrade to a release whose bundled runtime/dependencies support the current runner; validate Terraform setup and version pin behavior | Medium; action upgrade can change installer/runtime behavior |
| Runner annotation: Node.js 20 action runtimes are deprecated and forced onto Node.js 24 for `checkout`, `setup-terraform`, and `upload-artifact` | Those action revisions declare Node 20 while GitHub-hosted runners now execute them under Node 24 compatibility behavior | Medium / future-high | Review and update each action to a Node-24-compatible release, ideally pinned consistently and checked against release notes; avoid suppressing the annotation | Medium; action major revisions can alter inputs, permissions or artifact semantics |
| Node `DEP0040`: `punycode` deprecated during `upload-artifact@v4` | Bundled artifact action dependency still imports the deprecated Node core module | Medium | Upgrade `upload-artifact` when a compatible runtime release is available; verify artifact upload/download and retention | Medium |
| Node `DEP0005`: `Buffer()` deprecated during `download-artifact@v4` in apply run `44916862120` | Bundled download action dependency uses deprecated Buffer constructor under the runner runtime | Medium | Upgrade `download-artifact` to a Node-24-compatible release and validate exact plan artifact retrieval | Medium |

### Classification and impact
- Informational: the checkout `git init` hint.
- Deprecation/runtime compatibility: `DEP0169`, `DEP0040`, `DEP0005`, and the Node 20 forced-runtime annotation.
- Not observed: Terraform CLI warning, Azure DevOps provider warning, OCI/AWS provider warning, GitFlow failure, security failure, failed plan, or incorrect apply behavior.
- Current functional impact is none in the observed successful runs. Future risk is increased runner/action incompatibility when GitHub removes compatibility shims or an upstream dependency becomes an error.
- No evidence supports changing Terraform code, provider versions, backend configuration, credentials, GitFlow triggers, branch protection, or permissions as part of this warning remediation.

### Alternatives and recommendation
1. **Preferred — dependency update:** update the affected official/first-party actions to Node-24-compatible releases in a small, isolated PR. This addresses the source of the warnings and is reversible by reverting the action-version diff.
2. **Configuration adjustment:** only if the warning persists after action updates, use supported action inputs or a narrowly scoped runtime configuration. Do not globally suppress Node warnings.
3. **Point correction:** do not patch the runner's Node dependencies inside the workflow; that would be fragile and obscure ownership.
4. **Refactor:** not justified by the evidence. Keep job topology, Terraform commands, backend gates, protected apply, GitFlow and artifact handoff unchanged.

### Validation and rollback plan
- Before/after compare the same workflow on a feature branch and `master` push/manual dispatch: fmt, validate, static, plan, artifact upload, protected apply approval path, artifact download and post-apply plan.
- Confirm logs no longer contain the targeted action-runtime warnings, while retaining successful Terraform output and no new warnings/errors.
- Check that `contents: read`, secrets/variables, `terraform.tfplan` artifact naming/retention, `terraform-azuredevops-production`, and the GitFlow branch/release behavior remain unchanged.
- Roll back by reverting only the action-version changes if any job, artifact, approval gate or Terraform result changes unexpectedly. Do not rerun apply automatically during validation.

### Scope boundary
- This execution is discovery, analysis and documentation only. No workflow was modified; no commit, push, merge, release, tag, deployment, apply/destroy, state, secret or permission mutation was performed.

## Remediation Planning Continuation — 2026-11-21

### Current state reconciliation
- The warning study is complete, but remediation is pending. The Trello card is open in `Pipelines / Andamento`; its completed checklist represents the analysis, not implementation.
- The current repository workflow still uses `actions/checkout@v4`, `hashicorp/setup-terraform@v3`, `actions/upload-artifact@v4` and `actions/download-artifact@v4`. No action-version update has been made.
- Recent Git history confirms the repository's active work is still the Environment adoption feature branch; the warning-analysis documentation is local and uncommitted. No workflow change is present.
- Working behavior that must remain invariant: PR checks to `master`; plan only from push/manual dispatch; manual apply guarded by `terraform-azuredevops-production`; least-privilege `contents: read`; protected credential/backend gates; exact `terraform.tfplan` artifact handoff; release/tag behavior described by the repository's GitFlow documentation.

### Planned remediation activities

#### Activity A — update `hashicorp/setup-terraform` runtime compatibility
- **Problem:** `DEP0169` (`url.parse`) and runner warning that `hashicorp/setup-terraform@v3` targets Node 20 and is forced onto Node 24.
- **Root cause:** the action's declared/bundled Node runtime or dependency tree is not aligned with the current GitHub-hosted runner runtime.
- **Proposed change:** update only the `hashicorp/setup-terraform` action reference to a verified release compatible with Node 24; retain the existing Terraform version input and all job steps.
- **Files:** `.github/workflows/terraform-azuredevops.yml` only, plus any workflow documentation if behavior changes.
- **Risk:** Medium — action updates can change installation behavior or supported inputs.
- **Dependencies:** verify upstream release notes and compatibility before editing; no Terraform/provider change is required.
- **Validation:** run fmt, validate, static and plan jobs; confirm the requested Terraform version is installed; exercise manual plan and inspect logs for the targeted warning.
- **Rollback:** revert only the action reference to the previously verified revision.
- **Acceptance:** setup succeeds in every job that uses it; Terraform version remains `1.15.7`; all existing gates/checks remain intact; `DEP0169` and the Node-20 annotation from this action no longer appear.

#### Activity B — update artifact action runtime compatibility
- **Problem:** `DEP0040` (`punycode`) during `upload-artifact@v4` and `DEP0005` (`Buffer()`) during `download-artifact@v4` in the apply path.
- **Root cause:** bundled dependencies in the artifact actions use deprecated Node APIs under the runner runtime.
- **Proposed change:** update `actions/upload-artifact` and `actions/download-artifact` to verified Node-24-compatible releases as one artifact-contract change; preserve artifact name `terraform-plan-${{ github.run_id }}`, path, retention and download destination.
- **Files:** `.github/workflows/terraform-azuredevops.yml` only, plus documentation if the artifact contract changes (it should not).
- **Risk:** Medium — artifact action revisions can affect upload/download semantics, retention or hidden-file handling.
- **Dependencies:** verify release notes and test the exact plan artifact before any apply authorization.
- **Validation:** run plan and confirm artifact creation; run the manual apply-path job only after review/approval and confirm exact artifact download plus post-apply plan; inspect logs for targeted warnings.
- **Rollback:** revert both artifact action references together; do not alter the Terraform plan format or apply command.
- **Acceptance:** artifact upload/download succeeds with the same name and contents; no targeted artifact deprecation warnings remain; protected apply behavior is unchanged.

#### Activity C — decide on the checkout `git init` hint
- **Problem:** `actions/checkout@v4` emits Git's informational hint that the temporary repository defaults its initial branch to `master` and that Git 3.0 may change the default.
- **Root cause:** checkout initializes a temporary local repository without an explicit `init.defaultBranch`.
- **Proposed change:** default decision is no change because the hint does not affect the checked-out ref, repository default branch, GitFlow, or Terraform behavior. Revisit only if log cleanliness becomes an explicit requirement.
- **Files:** none under the default decision.
- **Risk:** Low; any unnecessary global Git configuration could create side effects in later steps.
- **Dependencies:** none.
- **Validation:** not applicable unless a scoped configuration is proposed; if proposed, verify checked-out refs and all Git commands.
- **Rollback:** remove the scoped configuration.
- **Acceptance:** record the decision and do not introduce unrelated Git configuration while remediating the Node warnings.

### Prioritization
1. Activity A — setup-terraform runtime compatibility: highest priority because it affects every Terraform job and combines a direct deprecation with the runner annotation.
2. Activity B — artifact runtime compatibility: second priority because it affects plan evidence and the protected apply handoff.
3. Activity C — checkout hint: defer; informational and low value compared with the runtime warnings.

### Cross-cutting risks and invariants
- Do not change job conditions, `needs`, `permissions`, environment protection, secrets/variables, backend initialization, plan gates, concurrency, branch triggers or GitFlow release/tag rules.
- Do not suppress stderr or set global Node warning flags; the objective is to remove the dependency source, not hide evidence.
- Initial validation should avoid apply; any apply-path test requires separate explicit authorization and a reviewed plan.
- If an action upgrade changes artifact or Terraform behavior, rollback the isolated action diff before considering broader refactoring.

### Checkpoint — setup-terraform Node 24 remediation
- Official GitHub release evidence: `hashicorp/setup-terraform v4.0.1`, published 2026-05-12, explicitly fixes the Node 24 `DEP0169 url.parse()` warning by updating `@hashicorp/js-releases` to `v1.7.7`.
- Local change: `.github/workflows/terraform-azuredevops.yml`, four references changed from `hashicorp/setup-terraform@v3` to `hashicorp/setup-terraform@v4.0.1`.
- Preserved invariants: `TERRAFORM_VERSION=1.15.7`, triggers, jobs, permissions, Environment, backend, artifact contract and apply conditions.
- Pending: remote publication/execution and evidence that the warning is absent from a run using the updated commit.
- Static validation update: actionlint v1.7.12 installed outside the repository at `/home/edwanderson/.local/bin/actionlint`; workflow lint passed with exit 0. YAML parse, `terraform fmt -check` and `git diff --check` also passed.
- Real validation run: GitHub Actions run `44922171924`, commit `601f2ea164c8aff5d37f4575024bf1b65d24a381`, workflow dispatch with `apply=false`, completed `success`. `fmt`, `validate`, `static` and `plan` passed; `Apply reviewed plan` was skipped; plan reported `No changes` and artifact upload succeeded.
- The updated `hashicorp/setup-terraform@v4.0.1` executed successfully in all four uses with Terraform `1.15.7`; no `DEP0169` was emitted in the setup step. Remaining `DEP0169` and `DEP0040` came from `actions/upload-artifact@v4`, and the remaining Node 20 annotation named `actions/checkout@v4` and `actions/upload-artifact@v4`. Those belong to separate remediation activities and are not evidence of a setup-terraform regression.

### Checkpoint — artifact action compatibility and local implementation
- Inventory found one workflow, `.github/workflows/terraform-azuredevops.yml`, with one upload and one download reference. No other artifact action usage exists under `.github/workflows`.
- Preserved contract: upload name `terraform-plan-${{ github.run_id }}`, source `${{ env.STACK_DIR }}/terraform.tfplan`, retention `3`, `if-no-files-found: error`, download destination `${{ env.STACK_DIR }}`, and the existing `plan`/protected `apply` conditions.
- Official stable releases inspected with `gh`: `actions/upload-artifact@v7.0.2` and `actions/download-artifact@v8.0.2`, both published 2026-10-07. Their tagged `action.yml` files declare `using: node24`; release notes update the shared `@actions/artifact` client to `6.3.1` and retain artifact-service behavior.
- Local implementation is limited to those two action references. No Terraform command, plan format, permissions, secrets, backend, job dependency or apply gate changed.
- Static evidence: YAML parse, `actionlint v1.7.12`, `terraform fmt -check` and `git diff --check` passed. Pending: authorized remote execution with `apply=false`. The current apply job is intentionally skipped in that mode, so direct `download-artifact` execution still requires a safe validation path; no apply will be run.

### Checkpoint — remote artifact validation
- Commit `3bc7748d10100d6c696e63ce556741221828b7c3` was pushed to `feature/azure-devops-environments-adoption` after authorization.
- GitHub Actions run `44926431941` (`workflow_dispatch`, `apply=false`) completed successfully for that commit. `fmt`, `validate`, `static` and `plan` passed; `Apply reviewed plan` was skipped.
- The plan reported `No changes`. `actions/upload-artifact@v7.0.2` uploaded `terraform-plan-44926431941` successfully with one file and the configured 3-day retention input; artifact size was 20,689 bytes and the GitHub artifact API reported it as unexpired.
- Targeted logs contain no `DEP0040`, `DEP0005` or `DEP0169`. The remaining annotation is the unrelated `actions/checkout@v4` Node 20 notice.
- The exact published artifact was downloaded through the GitHub Actions artifact API and contained a non-empty `terraform.tfplan` (26,324 bytes). This validates artifact service download/content without apply, but does not execute `actions/download-artifact@v8.0.2`; the protected apply job remains intentionally skipped and no apply was run.
