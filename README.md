# Terraform — Azure DevOps

Camada *live* de infraestrutura como código da organização Azure DevOps
`Tecnoform`. O projeto Azure DevOps `Infrastructure` já existe e é administrado
por esta configuração; módulos reutilizáveis ficam no repositório
[`Terraform-Modules`](https://github.com/Edwanderson94/Terraform-Modules).

## Cenário atual

A camada `azure-devops/organizations/Tecnoform/projects/infraestructure`
administra:

- repositórios Git do projeto `Infrastructure`;
- a definição da pipeline `Terraform State OCI Bootstrap` para o repositório
  `terraform-state`;
- o Variable Group `terraform-oci-bootstrap`, usado pela pipeline para as
  credenciais e configurações do bootstrap OCI.

O Variable Group é declarado em Terraform, mas só será criado após um `plan`
revisado e um `apply` local aprovado. O Azure DevOps não cria esse recurso
automaticamente a partir do YAML da pipeline.

O template reutilizável da pipeline pertence ao projeto `Platform`, no
repositório `patter-pipeline-terraform`. O repositório `terraform-state` apenas
o consome por referência versionada.

## Estrutura

```text
azure-devops/organizations/Tecnoform/
├── root.hcl
└── projects/infraestructure/
    ├── main.tf           # módulos de repositórios e Variable Group
    ├── pipeline.tf       # definição da pipeline de bootstrap
    ├── locals.tf         # repositórios e branches
    ├── variables.tf      # entradas do projeto e OCI
    ├── provider.tf
    ├── terragrunt.hcl
    └── README.md
```

O nome do diretório `infraestructure` é mantido por compatibilidade com o
estado e os caminhos existentes.

## Autenticação

Credenciais não devem ser versionadas. A execução local recebe os valores por
variáveis de ambiente:

```bash
export AZDO_PERSONAL_ACCESS_TOKEN='<seu-pat>'
export AZDO_ORG_SERVICE_URL='https://dev.azure.com/Tecnoform'
export OCI_REGION='<regiao>'
export OCI_OBJECT_STORAGE_NAMESPACE='<namespace>'
export OCI_TF_STATE_BUCKET='terraform-state'
export OCI_TENANCY_OCID='<tenancy-ocid>'
export OCI_USER_OCID='<user-ocid>'
export OCI_FINGERPRINT='<fingerprint>'
export OCI_COMPARTMENT_ID='<compartment-ocid>'
```

Os valores sensíveis devem permanecer fora do Git e dos logs. A chave OCI da
pipeline é um Secure File no Azure DevOps, não uma variável versionada aqui.

## Execução local

Como esta camada ainda não possui uma pipeline própria para executar o Terraform,
o fluxo atual é local:

```bash
cd azure-devops/organizations/Tecnoform/projects/infraestructure
terragrunt init
terragrunt plan
terragrunt apply
```

Execute `apply` somente após revisar o plano. A camada usa o backend OCI
configurado no `root.hcl`; não use state local temporário sem uma decisão
explícita de recuperação.

## Fluxo de mudanças

As alterações são feitas em `release/<versão>`, validadas com Terraform e
Terragrunt e depois mergeadas na `master`. A `master` recebe mudanças somente
por merge da release. Tags são criadas após o merge no commit resultante da
`master`.

## Documentação relacionada

- [Pipeline OCI](docs/oci-azure-devops-pipeline.md)
- [Camada Infrastructure](azure-devops/organizations/Tecnoform/projects/infraestructure/README.md)
- [Módulos reutilizáveis](https://github.com/Edwanderson94/Terraform-Modules)

## Licença

Este projeto está licenciado sob a [MIT License](LICENSE.md).
