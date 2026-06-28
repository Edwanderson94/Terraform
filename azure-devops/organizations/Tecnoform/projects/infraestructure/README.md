# Azure DevOps - Tecnoform / Infrastructure

Este diretorio e a camada live Terragrunt para gerenciar repositorios do projeto
`Infrastructure` na organizacao Azure DevOps `Tecnoform`.

## Contrato com o repo de modulos

- O modulo usado fica no repo `Terraform-Modules`.
- O source do modulo e definido em `../../root.hcl`.
- Por padrao local, o source aponta para:
  `../../../../../../Terraform-Modules/azure_devops/terraform-azuredevops-repositorios`.
- Em pipeline, sobrescreva o source com `TG_AZURE_DEVOPS_REPOSITORIES_MODULE_SOURCE`.
- Este diretorio nao deve ter `main.tf`, `variables.tf` ou recursos duplicados do modulo.

## Repositorios gerenciados

| Chave logica | Nome do repositorio | Branch padrao |
| --- | --- | --- |
| `aws` | `cloud-aws-infra` | `main` |
| `oci` | `cloud-oci-infra` | `develop` |
| `azure` | `cloud-azure-infra` | `uat` |
| `gcp` | `cloud-gcp-infra` | `main` |

Para renomear um repositorio, mantenha a chave logica e altere apenas o valor em
`repository_names`. Assim o nome muda sem trocar o endereco do recurso no state.

## Variaveis de ambiente

| Variavel | Obrigatoria | Uso |
| --- | --- | --- |
| `AZDO_PERSONAL_ACCESS_TOKEN` | Sim | PAT usado pelo provider Azure DevOps. |
| `AZDO_ORG_SERVICE_URL` | Nao | URL da organizacao. Padrao: `https://dev.azure.com/Tecnoform`. |
| `TG_AZURE_DEVOPS_REPOSITORIES_MODULE_SOURCE` | Nao | Source do modulo. Use em pipeline multi-repo. |
| `TG_TF_STATE_PATH` | Nao | Caminho do state local. Padrao: `terraform.tfstate` no diretorio live. |

## Execucao local

```bash
export AZDO_PERSONAL_ACCESS_TOKEN="<pat>"
export AZDO_ORG_SERVICE_URL="https://dev.azure.com/Tecnoform"
export TG_AZURE_DEVOPS_REPOSITORIES_MODULE_SOURCE="../../../../../../Terraform-Modules/azure_devops/terraform-azuredevops-repositorios"

terragrunt plan
terragrunt apply
```

## Execucao em pipeline

Em pipelines, faca checkout dos dois repositorios e aponte
`TG_AZURE_DEVOPS_REPOSITORIES_MODULE_SOURCE` para o checkout do repo
`Terraform-Modules`.

Exemplo conceitual:

```bash
export AZDO_PERSONAL_ACCESS_TOKEN="$AZDO_PERSONAL_ACCESS_TOKEN"
export AZDO_ORG_SERVICE_URL="https://dev.azure.com/Tecnoform"
export TG_AZURE_DEVOPS_REPOSITORIES_MODULE_SOURCE="$PIPELINE_WORKSPACE/Terraform-Modules/azure_devops/terraform-azuredevops-repositorios"

cd "$PIPELINE_WORKSPACE/Terraform/azure-devops/organizations/Tecnoform/projects/infraestructure"
terragrunt plan
```

## State

O backend atual e `local`. Para `apply` recorrente via pipeline, o state precisa
ser persistido entre execucoes ou migrado para um backend remoto compartilhado.
Sem isso, um runner novo nao tera historico dos recursos ja gerenciados.
