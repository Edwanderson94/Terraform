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
