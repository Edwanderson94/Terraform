# Task Plan: Acompanhamento Terraform e Azure DevOps

## Goal
Manter um acompanhamento persistente da arquitetura Terraform/Terragrunt, dos backends de state, das pipelines e dos controles Azure DevOps, com pendências e evidências atualizadas.

## Next Step
Projetar o contrato do módulo reutilizável de controles de pipeline no repositório `Terraform-Modules` e definir como o repositório consumidor o parametrizará.

## Current Phase
Phase 4

## Phases

### Phase 1: Requirements & Discovery
- [x] Understand user intent
- [x] Identify constraints
- [x] Document in findings.md
- **Status:** complete

### Phase 2: Planning & Structure
- [x] Define approach
- [x] Create project structure
- **Status:** complete

### Phase 3: Implementation
- [x] Execute the plan
- [x] Write to files before executing
- **Status:** complete

### Phase 4: Testing & Verification
- [x] Verify requirements met
- [x] Document test results
- **Status:** complete

### Phase 5: Delivery
- [x] Review outputs
- [x] Deliver to user
- **Status:** complete

### Phase 6: Reusable Pipeline Controls Module
- [ ] Definir o limite entre controles da pipeline e políticas do repositório
- [ ] Definir entradas, saídas e compatibilidade do módulo
- [ ] Mapear importação dos recursos já existentes no Azure DevOps
- [ ] Implementar o módulo em branch própria no `Terraform-Modules`
- [ ] Consumir o módulo no repositório Terraform e validar com `plan`
- **Status:** pending

### Phase 7: Azure DevOps Environments Adoption
- [x] Discover the live Azure DevOps organization/project, Environments, usages, permissions and checks using safe read-only evidence
- [x] Audit the reusable `azure_devops/environment` module and its import/plan compatibility
- [x] Audit the `infraestructure` consumer and identify the safest import-based adoption design
- [x] Implement the consumer configuration without changing remote resources or checks
- [x] Run safe formatting/validation checks and document risks; state-backed plan remains pending
- [x] Synchronize the Trello card with discovery, implementation and validation evidence
- [ ] Obtain approved backend/state context and review a read-only state-backed plan before any import/apply
- **Status:** complete

### Phase 8: Terraform CI/CD Warning Analysis
- [x] Read the warning-analysis objective and applicable repository guidance
- [x] Validate the exact Trello card and record attachment limitations
- [x] Inspect the workflow, triggers, permissions, actions, secrets/variables and GitFlow references
- [x] Inspect real GitHub Actions runs and logs, including an earlier comparison run
- [x] Document root causes, severity, remediation alternatives, validation and rollback
- [x] Synchronize the diagnosis and plan to the Trello card
- [ ] Obtain approval for a future implementation PR (out of scope for this study)
- **Status:** complete

### Phase 9: Warning Remediation Planning
- [x] Recover the current Trello, repository, workflow and prior-analysis context
- [x] Reconcile the prior diagnosis with the current workflow and GitFlow documentation
- [x] Define independent remediation activities with risks, dependencies, validation and rollback
- [x] Prioritize the activities and identify the first implementation step
- [x] Synchronize the plan, checklist and derived Trello activities without implementing changes
- [ ] Receive user approval before modifying the workflow
- **Status:** complete

### Phase 10: setup-terraform Node 24 Remediation
- [x] Revalidar o card e o estado atual do workflow
- [x] Confirmar no release oficial a correção do DEP0169 para Node 24
- [x] Atualizar somente as referências de `hashicorp/setup-terraform`
- [x] Executar validações estáticas locais
- [x] Registrar o marco de correção implementada no Trello
- [x] Obter autorização para push/execução remota e validar no GitHub Actions
- [ ] Registrar o marco de validação real no Trello
- **Status:** in_progress

### Phase 11: Artifact Actions Node 24 Remediation
- [x] Inventariar todos os workflows, jobs e referências de upload/download
- [x] Confirmar o contrato do artifact Terraform plan e compatibilidade das versões alvo
- [x] Atualizar somente `actions/upload-artifact` e `actions/download-artifact`
- [x] Executar validações estáticas locais
- [x] Obter autorização para commit/push e validação remota sem apply
- [ ] Validar upload e download reais e registrar evidências no Trello
- **Status:** in_progress

## Decisions Made
| Decision | Rationale |
|----------|-----------|
| Separar o control-plane Terraform do repositório `terraform-state` | O primeiro gerencia Azure DevOps; o segundo executa o bootstrap do bucket/state OCI. |
| Não registrar secrets, state, plans ou conteúdo de chaves | State, credenciais e planos são dados sensíveis e devem permanecer em stores protegidos. |
| Usar o Environment `terraform-oci-bootstrap` para proteger Apply | Approval e exclusive lock devem controlar a stage de Apply que consome o recurso. |
| Manter a proteção de `master` por política de revisão | A política bloqueante de 1 revisor protege o branch sem quebrar o template cross-project fixado por SHA. |
| Adicionar controles opcionais ao módulo `azure_devops/pipelines` | O repositório consumidor deve apenas declarar a intenção e os parâmetros; a implementação Azure DevOps fica centralizada e versionada. |
| Manter políticas de branch fora do módulo de pipelines | A política pertence ao repositório/branch e pode ser reutilizada independentemente da definição da pipeline. |

## Errors Encountered
| Error | Resolution |
|-------|------------|
| O primeiro comando do inicializador expandiu `PWF_SKILL_DIR` antes do `export` | Reexecutado com a variável exportada; os arquivos de planejamento foram criados. |
| Branch Control falhou nas execuções 1994 e 1995 ao avaliar o template cross-project fixado por SHA | O check específico foi removido; a proteção de `master` e os demais controles permanecem ativos. |
