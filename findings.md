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
