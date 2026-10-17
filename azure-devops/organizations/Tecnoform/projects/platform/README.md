# Azure DevOps — Tecnoform / Platform

Camada Terragrunt que cria o projeto privado `Platform` na organizacao
Azure DevOps `Tecnoform`.

O projeto e o plano de controle de automacao: pipelines de bootstrap,
templates reutilizaveis e governanca de execucao. Segredos, Secure Files,
Variable Groups, Environments e pipelines sao configurados em camadas e
aprovacoes separadas; eles nao sao criados por esta camada inicial.

## Backend de bootstrap

Esta e uma camada temporaria de bootstrap e usa state local em
`terraform.tfstate`, neste mesmo diretorio. O arquivo e ignorado pelo Git.
Nao o envie, anexe a tarefas ou copie para pipelines. Depois que o backend OCI
for provisionado, migre esse state somente pelo procedimento aprovado de
backup, teste, migracao, lock e rollback.

## Pre-requisitos

- PAT Azure DevOps fornecido por variavel de ambiente, nunca em arquivos.

```bash
export AZDO_ORG_SERVICE_URL='https://dev.azure.com/Tecnoform'
export AZDO_PERSONAL_ACCESS_TOKEN='<pat>'
```

## Validacao

```bash
terragrunt hcl fmt --check
terragrunt init
terragrunt plan
```

Revise o plano antes de qualquer `apply`. A primeira execucao cria somente o
projeto Azure DevOps `Platform`.
