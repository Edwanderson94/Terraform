<!-- BEGIN_TF_DOCS -->
# Repositório Terraform

Bem-vindo à documentação deste repositório Terraform! Este espaço foi criado para compartilhar as implementações realizadas ao longo da minha jornada como DevOps e SRE, explorando o uso dessa poderosa ferramenta de infraestrutura como código.

## Objetivo

Este repositório tem como propósito centralizar módulos, documentações e exemplos práticos relacionados ao uso do Terraform. Aqui você encontrará:

- **Módulos reutilizáveis** para provisionamento de recursos.
- **Guia de comandos** para facilitar o uso do Terraform.
- **Estruturas de implementação** aplicadas em plataformas como:
  - **Azure DevOps**

Explore, aprenda e contribua para expandir este repositório com ideias e melhorias!

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
| <a name="module_azuredevops_repository"></a> [azuredevops\_repository](#module\_azuredevops\_repository) | git::https://github.com/Edwanderson94/Terraform-Modules.git//azure_devops/terraform-azuredevops-repositorios | develop |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_org_service_url"></a> [org\_service\_url](#input\_org\_service\_url) | URL da sua organization no Azure DevOps | `string` | n/a | yes |
| <a name="input_personal_access_token"></a> [personal\_access\_token](#input\_personal\_access\_token) | PAT de acesso a sua organization no Azure DevOps | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Nome do projeto | `string` | n/a | yes |
| <a name="input_repositories"></a> [repositories](#input\_repositories) | Mapa de repositórios a serem criados. A chave do mapa deve ser um identificador lógico estável e o valor define o nome do repositório e branch padrão. No Terragrunt, esse mapa é montado a partir de `repository_names` e `repository_default_branches` para facilitar renomeações futuras. | <pre>map(object({<br/>    name           = string<br/>    default_branch = string<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_module_version"></a> [module\_version](#output\_module\_version) | n/a |

# Considerações Finais

Este repositório foi desenvolvido com o objetivo de oferecer uma infraestrutura mais robusta e escalável, utilizando Terraform de maneira simples e eficiente no universo dos providers. Aqui estão armazenadas estruturas, desenvolvimentos e documentações baseadas em minha experiência prática.

## Licença

Este módulo está licenciado sob MIT. Para mais informações, consulte o arquivo [LICENSE](./LICENSE).

## Contribuição

Contribuições são muito bem-vindas! Se você deseja colaborar, siga as instruções abaixo:

1. Envie pull requests com suas alterações ou melhorias.
2. Caso encontre algum erro ou tenha sugestões, crie uma *issue* no repositório.

Agradecemos pela sua colaboração e interesse!

---

**Desenvolvido por**
Edwanderson Luiz Pereira
<!-- END_TF_DOCS -->
