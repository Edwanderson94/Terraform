# Azure DevOps — Tecnoform / Infrastructure

Esta é a camada *live* Terragrunt que administra os repositórios do projeto
Azure DevOps existente `Infrastructure`, dentro da organização `Tecnoform`.

## Como a camada funciona

- `terragrunt.hcl` inclui `../../root.hcl` e define `project_name = "Infrastructure"`.
- `root.hcl` recebe a URL da organização e o PAT por variáveis de ambiente, além
  de configurar o backend local atual.
- `main.tf` chama o módulo reutilizável `azure_devops/repos` do repositório
  `Terraform-Modules`, fixado na tag `v1.3.2`.
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

O padrão de branches é `develop`, `homolog` e `master`. Alterações de nomes,
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

O backend atual é local. Não use `apply` em um runner efêmero de pipeline sem
persistir o state ou migrá-lo antes para um backend remoto compartilhado.
