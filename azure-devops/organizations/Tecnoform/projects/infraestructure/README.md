# Azure DevOps - Tecnoform / Infrastructure

Este diretorio e a camada live Terragrunt para gerenciar repositorios do projeto
`Infrastructure` na organizacao Azure DevOps `Tecnoform`.

## Contrato com o repo de modulos

- O modulo usado fica no repo `Terraform-Modules`.
- O source do modulo e definido no `main.tf` deste diretorio live.
- Por padrao, o source aponta para o repo remoto:
  `git::https://github.com/Edwanderson94/Terraform-Modules.git//azure_devops/repos?ref=v1.3.0`.
- Este diretorio contem os `.tf` que chamam os modulos reutilizaveis.
- O `terragrunt.hcl` e opcional e serve para injetar inputs/backend em execucoes com Terragrunt.

## Repositorios gerenciados

| Chave logica | Nome do repositorio | Branch padrao |
| --- | --- | --- |
| `aws` | `cloud-aws-infra` | `master` |
| `oci` | `cloud-oci-infra` | `master` |
| `azure` | `cloud-azure-infra` | `master` |
| `gcp` | `cloud-gcp-infra` | `master` |

Para renomear um repositorio, mantenha a chave logica e altere apenas o valor em
`repository_names`. Assim o nome muda sem trocar o endereco do recurso no state.

## Variaveis de ambiente

| Variavel | Obrigatoria | Uso |
| --- | --- | --- |
| `AZDO_PERSONAL_ACCESS_TOKEN` | Sim | PAT usado pelo provider Azure DevOps. |
| `AZDO_ORG_SERVICE_URL` | Nao | URL da organizacao. Padrao: `https://dev.azure.com/Tecnoform`. |
| `TG_TF_STATE_PATH` | Nao | Caminho do state local. Padrao: `terraform.tfstate` no diretorio live. |

## Execucao local

```bash
export AZDO_PERSONAL_ACCESS_TOKEN="<pat>"
export AZDO_ORG_SERVICE_URL="https://dev.azure.com/Tecnoform"
terragrunt plan
terragrunt apply
```

## Execucao em pipeline

Em pipelines, o Terraform baixa o modulo diretamente do GitHub pelo `source`
definido no `main.tf`.

Exemplo conceitual:

```bash
export AZDO_PERSONAL_ACCESS_TOKEN="$AZDO_PERSONAL_ACCESS_TOKEN"
export AZDO_ORG_SERVICE_URL="https://dev.azure.com/Tecnoform"

cd "$PIPELINE_WORKSPACE/Terraform/azure-devops/organizations/Tecnoform/projects/infraestructure"
terraform init
terraform plan
```

Para producao, mantenha o `ref` apontando para uma tag versionada do modulo,
como `ref=v1.3.0`, em vez de branch mutavel como `develop`.

## State

O backend atual e `local`. Para `apply` recorrente via pipeline, o state precisa
ser persistido entre execucoes ou migrado para um backend remoto compartilhado.
Sem isso, um runner novo nao tera historico dos recursos ja gerenciados.
