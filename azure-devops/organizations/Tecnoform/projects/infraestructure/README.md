<!-- BEGIN_TF_DOCS -->
# Repositório Terraform

Bem-vindo à documentação deste repositório Terraform! Este espaço foi criado para compartilhar as implementações realizadas ao longo da minha jornada como DevOps e SRE, explorando o uso dessa poderosa ferramenta de infraestrutura como código.

## Objetivo

Este repositório tem como propósito centralizar módulos, documentações e exemplos práticos relacionados ao uso do Terraform. Aqui você encontrará:

- **Módulos reutilizáveis** para provisionamento de recursos.
- **Guia de comandos** para facilitar o uso do Terraform.
- **Estruturas de implementação** aplicadas em plataformas como:
  - **Azure DevOps**
  - **AWS**

Explore, aprenda e contribua para expandir este repositório com ideias e melhorias!

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuredevops"></a> [azuredevops](#requirement\_azuredevops) | 1.4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuredevops"></a> [azuredevops](#provider\_azuredevops) | 1.4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_azuredevops_repository"></a> [azuredevops\_repository](#module\_azuredevops\_repository) | ../../../../../modules/azure-devops/azuredevops_repository | 1.1.0 |

## Resources

| Name | Type |
|------|------|
| [azuredevops_project.project_infra](https://registry.terraform.io/providers/microsoft/azuredevops/1.4.0/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_org_service_url"></a> [org\_service\_url](#input\_org\_service\_url) | URL da sua organization no Azure DevOps | `string` | `"https://dev.azure.com/Tecnoform"` | no |
| <a name="input_personal_access_token"></a> [personal\_access\_token](#input\_personal\_access\_token) | PAT de acesso a sua organization no Azure DevOps | `string` | `"yd7oeczyfwhms7epd5eu6uoir4clxqensvbuiuqat3zupldtopvq"` | no |
| <a name="input_repositories"></a> [repositories](#input\_repositories) | Lista de repositórios com suas configurações | <pre>list(object({<br/>    name           = string<br/>    default_branch = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "default_branch": "main",<br/>    "name": "repo-01"<br/>  },<br/>  {<br/>    "default_branch": "develop",<br/>    "name": "repo-02"<br/>  },<br/>  {<br/>    "default_branch": "develop",<br/>    "name": "repo-03"<br/>  },<br/>  {<br/>    "default_branch": "develop",<br/>    "name": "repo-04"<br/>  },<br/>  {<br/>    "default_branch": "develop",<br/>    "name": "repo-05"<br/>  }<br/>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_module_repository_default_branch"></a> [module\_repository\_default\_branch](#output\_module\_repository\_default\_branch) | Branch Default do repositório que foi criado a partir do módulo |
| <a name="output_module_repository_ids"></a> [module\_repository\_ids](#output\_module\_repository\_ids) | ID do repositório que foi criado pelo módulo |
| <a name="output_module_repository_names"></a> [module\_repository\_names](#output\_module\_repository\_names) | Nome do repositório que foi criado a partir do módulo |

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