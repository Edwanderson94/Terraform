# Terraform — Azure DevOps

Camada *live* de infraestrutura como código para administrar recursos do Azure
DevOps com Terraform e Terragrunt. O repositório contém a configuração real da
organização; módulos reutilizáveis ficam no repositório
[`Terraform-Modules`](https://github.com/Edwanderson94/Terraform-Modules).

## Escopo atual

O estado atual gerencia os repositórios Git do projeto existente `Infrastructure`
na organização Azure DevOps `Tecnoform`. A organização e o projeto não são
criados por esta stack.

Recursos administrados:

- `cloud-aws-infra`
- `cloud-oci-infra`
- `cloud-azure-infra`
- `cloud-gcp-infra`
- `terraform-state`

As branches padronizadas são `develop`, `homolog` e `master`, sendo `master` a
branch padrão. A lista de branches criadas, removidas ou renomeadas fica em
`locals.tf` da camada do projeto.

## Estrutura atual

```text
.
├── azure-devops/
│   └── organizations/
│       └── Tecnoform/
│           ├── root.hcl
│           └── projects/
│               └── infraestructure/
│                   ├── terragrunt.hcl
│                   ├── main.tf
│                   ├── locals.tf
│                   ├── variables.tf
│                   ├── provider.tf
│                   ├── moved.tf
│                   └── README.md
├── azure-pipelines.yml
├── docs/
│   └── oci-azure-devops-pipeline.md
├── .gitignore
└── README.md
```

> O nome do diretório `infraestructure` é mantido por compatibilidade com o
> estado e os caminhos existentes.

## Autenticação e configuração

As credenciais não devem ser versionadas. O Terragrunt lê as variáveis abaixo:

| Variável | Obrigatória | Descrição |
| --- | --- | --- |
| `AZDO_PERSONAL_ACCESS_TOKEN` | Sim | PAT do Azure DevOps com as permissões necessárias. |
| `AZDO_ORG_SERVICE_URL` | Não | URL da organização. Padrão: `https://dev.azure.com/Tecnoform`. |
| `OCI_TF_STATE_BUCKET` | Sim | Bucket privado da OCI que armazena o state. |
| `OCI_OBJECT_STORAGE_NAMESPACE` | Sim | Namespace do Object Storage da tenancy OCI. |
| `OCI_TENANCY_OCID` | Para acesso à OCI | OCID da tenancy. |
| `OCI_USER_OCID` | Para acesso à OCI | OCID do usuário técnico da pipeline. |
| `OCI_FINGERPRINT` | Para acesso à OCI | Fingerprint da API signing key. |
| `OCI_PRIVATE_KEY_PATH` | Para acesso à OCI | Caminho local da API signing key PEM. |
| `OCI_REGION` | Para acesso à OCI | Região da OCI. |

Exemplo para a sessão atual:

```bash
export AZDO_PERSONAL_ACCESS_TOKEN='<seu-pat>'
export AZDO_ORG_SERVICE_URL='https://dev.azure.com/Tecnoform'
export OCI_TF_STATE_BUCKET='<bucket-de-state>'
export OCI_OBJECT_STORAGE_NAMESPACE='<namespace-oci>'
```

## Uso local

```bash
cd azure-devops/organizations/Tecnoform/projects/infraestructure
terragrunt init
terragrunt plan
terragrunt apply
```

Execute `apply` somente após revisar o plano. O arquivo de state e arquivos com
segredos são ignorados pelo Git.

## State e automação

O backend é OCI Object Storage: compartilhado, com state locking nativo e
criptografia em repouso. A pipeline YAML em `azure-pipelines.yml` valida pull
requests e aplica em `master` após a migração única do state e os controles do
Environment. Siga o procedimento completo em
[OCI e Azure Pipelines](docs/oci-azure-devops-pipeline.md); ele define o bucket,
as credenciais técnicas, os segredos de Azure DevOps e o rollback da migração.

## Evolução planejada

Os próximos componentes recomendados são projeto Azure DevOps, grupos e
permissões, políticas de branch, pipelines e service connections. Cada
componente deve ter sua própria camada Terragrunt, mantendo módulos genéricos em
`Terraform-Modules`.

## Contribuição

Crie uma branch a partir de `develop`, valide com `terragrunt plan` e abra um
pull request. Atualmente `master` e `develop` estão sincronizadas; novas
alterações devem passar pelo fluxo de PR.

## Licença

Este projeto está licenciado sob a [MIT License](LICENSE.md).
