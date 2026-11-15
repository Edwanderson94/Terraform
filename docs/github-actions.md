# GitHub Actions — Terraform Azure DevOps

O workflow `.github/workflows/terraform-azuredevops.yml` executa o stack
`azure-devops/organizations/Tecnoform/projects/infraestructure` diretamente no
GitHub Actions. O Terraform continua provisionando recursos no Azure DevOps; o
Azure Pipelines deixa de ser o executor desse repositório.

## Fluxo

- Pull requests para `master` executam `fmt`, `validate` e verificações estáticas.
- Pushes em `master` executam o `plan` somente quando o backend efetivo é OCI e
  publicam o plano por três dias como artefato da mesma execução. Se o stack
  ainda estiver com backend local, o workflow falha explicitamente antes do
  plano.
- `workflow_dispatch` com `apply=true` executa novo `plan` e, após aprovação do
  Environment `terraform-azuredevops-production`, aplica exatamente esse plano.
- `concurrency` serializa execuções por referência GitHub; o locking do backend
  OCI continua sendo obrigatório.
- O apply fica bloqueado até `OCI_TF_STATE_MIGRATED=true` e até o backend efetivo
  ser confirmado como `oci`.

O workflow não cria o bucket nem migra state automaticamente. A configuração do
backend OCI é gerada pelo Terragrunt com o bucket, namespace e chave da camada;
a chave privada é escrita somente no diretório temporário do runner. Backup,
migração aprovada, teste de locking e ativação de
`OCI_TF_STATE_MIGRATED=true` continuam sendo pré-requisitos operacionais para
habilitar o `plan`.

## Secrets e Environment

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
- `OCI_TF_STATE_MIGRATED`
- `OCI_PRIVATE_KEY` (conteúdo PEM da chave de assinatura OCI, usado apenas no
  diretório temporário do runner)
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_SESSION_TOKEN` (opcional)
- `AWS_REGION`
- `AWS_TF_STATE_BUCKET`
- `AWS_TF_STATE_KEY`
- `AWS_TF_STATE_MIGRATED`

O PAT deve ter somente as permissões necessárias para a camada Azure DevOps. A
chave privada OCI deve ser armazenada como Secret protegido; o workflow a
materializa apenas no diretório temporário do runner e não a publica como
artefato. O nome `gh-pipeline-tf-state` é definido no workflow e não deve ser
substituído por um Secret ou compartilhado com a pipeline Azure DevOps, que usa
o bucket `az-pipeline-tf-state`.

### Environment `terraform-azuredevops-production`

Configure aprovação obrigatória e restrinja o Environment ao workflow. O secret
`OCI_TF_STATE_MIGRATED` deve ser `true` somente após backup, migração aprovada
do state, teste de locking e validação do rollback. Ele pode ser mantido como
secret do repositório para permitir o `plan`; o Environment continua protegendo
qualquer execução de `apply`.

## Operação e rollback

O plano é temporário e usado apenas na mesma execução. Para rollback, reverta a
alteração por pull request e gere um novo plano; não reutilize artefatos antigos
nem edite o state manualmente. Nenhum state, plano persistente, PAT ou chave deve
ser commitado no repositório.
