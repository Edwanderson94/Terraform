# GitHub Actions — Terraform Azure DevOps

O workflow `.github/workflows/terraform-azuredevops.yml` valida e planeja a
camada `azure-devops/organizations/Tecnoform/projects/infraestructure`.

## Fluxo

- Pull requests para `master` executam `fmt`, validação, verificações estáticas
  e `plan`; nenhum apply é executado.
- Pushes para `master` repetem a validação e publicam o plano como artefato
  temporário de três dias.
- `workflow_dispatch` permite solicitar apply com a opção `apply=true`, mas o
  job depende do Environment protegido `terraform-azuredevops-production`.
- O apply baixa o plano da mesma execução, exige `OCI_TF_STATE_MIGRATED=true`
  no Environment e bloqueia a execução se o backend efetivo não for `oci`.
- A concorrência é serializada por referência GitHub para evitar duas operações
  simultâneas no mesmo stack. O locking do backend OCI continua obrigatório.

## Configuração protegida

Configure no GitHub, sem adicionar valores ao repositório:

### Repository secrets

- `AZDO_ORG_SERVICE_URL`
- `AZDO_PERSONAL_ACCESS_TOKEN`
- `OCI_REGION`
- `OCI_OBJECT_STORAGE_NAMESPACE`
- `OCI_TENANCY_OCID`
- `OCI_USER_OCID`
- `OCI_FINGERPRINT`
- `OCI_COMPARTMENT_ID`
- `OCI_TF_STATE_BUCKET`

O PAT deve ter somente as permissões necessárias para a camada Azure DevOps.
Não use PAT em texto do workflow, logs, artefatos ou arquivos Terraform.

### Environment `terraform-azuredevops-production`

Configure aprovação obrigatória pelos responsáveis de infraestrutura e acesso
restrito ao workflow. Adicione neste Environment o secret:

- `OCI_TF_STATE_MIGRATED`: use `true` somente após a migração aprovada do state
  local para o backend OCI e um teste de locking bem-sucedido.

O workflow não habilita a migração. Ela exige backup criptografado externo,
`terragrunt init -migrate-state`, revisão do plano, teste de bloqueio e plano de
rollback antes de alterar esse secret.

## Rollback e artefatos

O apply usa exatamente o `terraform.tfplan` produzido no mesmo run. Para
rollback, reverta o commit por pull request e gere um novo plano; não reutilize
um artefato antigo nem edite state manualmente. O artefato do plano tem retenção
curta porque pode conter valores sensíveis e deve ser acessível apenas às
equipes autorizadas no repositório.

Enquanto o state permanecer local, o apply fica bloqueado intencionalmente.
Executar apply em um runner efêmero com state local poderia perder o state ou
criar concorrência sem locking.
