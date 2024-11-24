<!-- BEGIN_TF_DOCS -->
# Repositório Terraform - Documentação da Chamada do Módulo

Esta documentação foi elaborada com o objetivo de explicar o funcionamento da chamada do módulo Terraform para os projetos do Azure DevOps na organização **Tecnoform**. Neste caso, estamos utilizando o projeto já existente denominado **Infrastructure**.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuredevops"></a> [azuredevops](#provider\_azuredevops) | 1.4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_azuredevops_repository"></a> [azuredevops\_repository](#module\_azuredevops\_repository) | git::https://github.com/Edwanderson94/Terraform-Modules.git//terraform-azdo-modules/azuredevops_repository | develop |

## Resources

| Name | Type |
|------|------|
| [azuredevops_project.project_infra](https://registry.terraform.io/providers/hashicorp/azuredevops/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_org_service_url"></a> [org\_service\_url](#input\_org\_service\_url) | URL da sua organization no Azure DevOps | `string` | n/a | yes |
| <a name="input_personal_access_token"></a> [personal\_access\_token](#input\_personal\_access\_token) | PAT de acesso a sua organization no Azure DevOps | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Nome do projeto | `string` | n/a | yes |
| <a name="input_repositories"></a> [repositories](#input\_repositories) | Mapa de repositórios a serem criados, com os nomes e branches padrões | <pre>map(object({<br/>    name           = string<br/>    default_branch = string<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_module_version"></a> [module\_version](#output\_module\_version) | n/a |

# Considerações Finais

Este repositório foi criado com o objetivo de provisionar recursos no Azure DevOps utilizando **Terraform** e **Terragrunt**, buscando proporcionar um gerenciamento mais eficiente e automatizado dos recursos dentro do ecossistema Azure DevOps.

## Contribuição

Contribuições são sempre bem-vindas! Se você deseja colaborar, siga as instruções abaixo:

1. Envie um *pull request* com suas alterações ou melhorias.
2. Caso encontre algum erro ou tenha sugestões, abra uma *issue* no repositório.

Agradecemos por seu interesse e colaboração!

---

**Desenvolvido por**  
Edwanderson Luiz Pereira
<!-- END_TF_DOCS -->