# ======================================================
# Owner: Edwanderson
# Description: Provisionando Projeto e Configurações 
# Project: Azure DevOps com Terraform
# =======================================================

# ============================================================
# Captura de informações sobre Projeto
# ============================================================
data "azuredevops_project" "project_infra" {
  name = "Infrastructure"
}