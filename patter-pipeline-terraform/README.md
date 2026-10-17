# patter-pipeline-terraform

Padrão reutilizável de Azure Pipelines para stacks Terraform com Terragrunt e
state remoto no OCI Object Storage.

## Uso em outro repositório

Crie `azure-pipelines.yml` no repositório de infraestrutura:

```yaml
trigger:
  branches:
    include: [develop, homolog, master]

pr:
  branches:
    include: [develop, homolog, master]

resources:
  repositories:
    - repository: terraformPipeline
      type: git
      name: Platform/patter-pipeline-terraform
      ref: refs/heads/master

extends:
  template: templates/terraform-terragrunt.yml@terraformPipeline
  parameters:
    workingDirectory: infra/oci
    variableGroup: terraform-oci
    secureFile: oci-terraform-api-key.pem
    environment: terraform-oci-production
    stateMigratedVariable: OCI_TF_STATE_MIGRATED
```

Configure no Azure DevOps o Variable Group indicado com PAT, OCIDs, região,
namespace e bucket OCI. Cadastre a chave privada OCI como Secure File. O
Environment usado no parâmetro deve ter aprovação e lock configurados. Restrinja
o acesso desses recursos às pipelines autorizadas.

## Fluxo

- PRs e pushes em `develop`, `homolog` e `master`: formatação e validação.
- Push em `master`, após a migração do state: plano Terraform publicado somente
  como artefato da execução e stage de apply protegido pelo Environment.
- O apply consome o mesmo plano gerado no stage anterior.
- O modo `bootstrapMode: true` permite executar manualmente a criação inicial
  do backend sem exigir `master` nem `OCI_TF_STATE_MIGRATED=true`. O apply fica
  desabilitado por padrão e exige `apply: true` mais aprovação do Environment.
- No bootstrap, o state nasce localmente no agente do stage de apply e é
  migrado imediatamente para OCI depois da criação do bucket. O state não é
  publicado como artefato. Se a migração falhar em agente hospedado, o state
  local pode ser perdido ao final do job; não repita o apply. Confirme o bucket
  existente e faça importação/reconciliação controlada antes de nova execução.

Planos Terraform podem conter valores sensíveis. Restrinja acesso e retenção dos
artefatos da pipeline. State, arquivos `.terraform` e chaves nunca são
publicados.

## Parâmetros

| Parâmetro | Padrão | Uso |
| --- | --- | --- |
| `workingDirectory` | `.` | Diretório da camada Terragrunt. |
| `variableGroup` | `terraform-oci` | Grupo protegido com variáveis de autenticação. |
| `secureFile` | `oci-terraform-api-key.pem` | Secure File da chave OCI. |
| `environment` | `terraform-oci-production` | Environment para aprovação/lock do apply. |
| `stateMigratedVariable` | `OCI_TF_STATE_MIGRATED` | Variável que habilita o plano e apply em `master` quando igual a `true`. |
| `bootstrapMode` | `false` | Libera execução manual de bootstrap usando state local e migra o state para OCI após criar o bucket. |
| `apply` | `false` | No bootstrap, inclui o apply somente quando marcado; exige aprovação do Environment. |
| `terraformVersion` | `1.15.7` | Versão fixada do Terraform. |
| `terragruntVersion` | `1.0.8` | Versão fixada do Terragrunt. |

Cada repositório consumidor deve validar seu `workingDirectory` e adaptar o
grupo de variáveis e Secure File ao backend OCI utilizado.

## Skill para agentes

A skill `terraform-pipeline-integration`, em
`.agents/skills/terraform-pipeline-integration/SKILL.md`, orienta agentes a
integrar este template em outros repositórios. Para disponibilizá-la também
dentro de um repositório consumidor, copie essa pasta para
`.agents/skills/terraform-pipeline-integration/` nele.

As decisões duradouras e limites para alterações neste repositório estão em
[`AGENTS.md`](AGENTS.md) e [`.codex/steering/terraform-pipeline.md`](.codex/steering/terraform-pipeline.md).
