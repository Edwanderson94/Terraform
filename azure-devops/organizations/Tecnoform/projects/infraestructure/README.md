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
| <a name="module_azuredevops_repository"></a> [azuredevops\_repository](#module\_azuredevops\_repository) | ../../../../../modules/azure-devops/azuredevops_repository | n/a |

## Resources

| Name | Type |
|------|------|
| [azuredevops_project.project_infra](https://registry.terraform.io/providers/microsoft/azuredevops/1.4.0/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_branch"></a> [default\_branch](#input\_default\_branch) | Nome do branch padrão do repositório | `string` | `"master"` | no |
| <a name="input_org_service_url"></a> [org\_service\_url](#input\_org\_service\_url) | n/a | `string` | `"https://dev.azure.com/Tecnoform"` | no |
| <a name="input_personal_access_token"></a> [personal\_access\_token](#input\_personal\_access\_token) | n/a | `string` | `"yd7oeczyfwhms7epd5eu6uoir4clxqensvbuiuqat3zupldtopvq"` | no |
| <a name="input_repository_name"></a> [repository\_name](#input\_repository\_name) | Nome do repositório no Azure DevOps | `string` | `"example-repo-module"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_module_repository_default_branch"></a> [module\_repository\_default\_branch](#output\_module\_repository\_default\_branch) | The default branch of the Azure DevOps repository from the module |
| <a name="output_module_repository_name"></a> [module\_repository\_name](#output\_module\_repository\_name) | The name of the Azure DevOps repository from the module |
