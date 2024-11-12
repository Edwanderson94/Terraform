terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "1.4.0"
    }
  }
}

provider "azuredevops" {
  org_service_url       = "https://dev.azure.com/Tecnoform"
  personal_access_token = "yd7oeczyfwhms7epd5eu6uoir4clxqensvbuiuqat3zupldtopvq"
}