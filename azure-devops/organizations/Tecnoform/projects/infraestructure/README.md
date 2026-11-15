# Azure DevOps — Tecnoform / Infrastructure

Esta é a camada *live* Terragrunt que administra os repositórios do projeto
Azure DevOps existente `Infrastructure`, dentro da organização `Tecnoform`.

## Como a camada funciona

- `terragrunt.hcl` inclui `../../root.hcl` e define `project_name = "Infrastructure"`.
- `root.hcl` recebe a URL da organização e o PAT por variáveis de ambiente, além
  de gerar a configuração do backend OCI para esta camada.
- `main.tf` chama o módulo reutilizável `azure_devops/repos` do repositório
  `Terraform-Modules`, fixado na tag `v1.3.2`.
- `main.tf` também declara os Variable Groups `terraform-oci-bootstrap` e
  `terraform-aws-cloud` pelo módulo reutilizável de Variable Groups.
- `locals.tf` declara os repositórios e o padrão de branches.
- `moved.tf` preserva endereços de recursos no state após a extração para o módulo.

## Repositórios e branches

| Chave lógica | Repositório | Branch padrão |
| --- | --- | --- |
| `aws` | `cloud-aws-infra` | `master` |
| `oci` | `cloud-oci-infra` | `master` |
| `azure` | `cloud-azure-infra` | `master` |
| `gcp` | `cloud-gcp-infra` | `master` |
| `terraform_state` | `terraform-state` | `master` |

A única branch obrigatória é `master`. Branches adicionais existentes são preservadas.
Alterações de nomes,
branches ou exclusões devem ser feitas em `locals.tf` e revisadas no plano antes
do apply.

## Pré-requisitos

- Terraform `>= 1.0, < 2.0`
- Terragrunt
- PAT do Azure DevOps com permissões compatíveis com a administração de
  repositórios e branches no projeto

Configure a sessão sem salvar o token em arquivos versionados:

```bash
export AZDO_PERSONAL_ACCESS_TOKEN='<seu-pat>'
export AZDO_ORG_SERVICE_URL='https://dev.azure.com/Tecnoform'
```

## Execução

No diretório atual:

```bash
terragrunt init
terragrunt plan
terragrunt apply
```

O backend desta camada é o OCI Object Storage. Antes de habilitar o
`plan`/`apply` do GitHub Actions, faça backup e migração aprovados, valide o
locking e confirme que o backend efetivo é `oci`. O fluxo não executa essa
migração automaticamente.

## Variable Group AWS

O grupo `terraform-aws-cloud` é gerenciado exclusivamente por Terraform. Os
valores são recebidos por variáveis de ambiente no Terragrunt e não ficam
versionados:

- não secretas: `AWS_ACCESS_KEY_ID`, `AWS_REGION`, `AWS_TF_STATE_BUCKET`,
  `AWS_TF_STATE_KEY` e `AWS_TF_STATE_MIGRATED`;
- secretas: `AWS_SECRET_ACCESS_KEY` e `AWS_SESSION_TOKEN` quando forem usadas
  credenciais temporárias.

O `AWS_SESSION_TOKEN` é opcional para credenciais de longa duração, mas, quando
presente, deve pertencer à mesma sessão que o access key ID e o secret access
key. A identidade da pipeline deve ser dedicada e de menor privilégio; não use
credenciais da conta root.
