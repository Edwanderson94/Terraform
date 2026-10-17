# Terraform — chamada do módulo Azure DevOps

Esta camada administra repositórios do projeto Azure DevOps já existente
**Infrastructure**, na organização **Tecnoform**. Ela usa Terragrunt para
configuração compartilhada e o módulo remoto `azure_devops/repos`, fixado na
versão `v1.3.2`.

As credenciais são fornecidas por `AZDO_PERSONAL_ACCESS_TOKEN`; elas nunca
devem ser incluídas em arquivos Terraform ou documentação versionada.
