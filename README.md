# Terraform - Lista de Comandos

---

### 1. Init

| Sintaxe  | Contexto | Descrição |
| :---    | :----    | :---    |
| terraform init | Gerenciamento | -- |

---

### 2. Plan

| Sintaxe  | Contexto | Descrição |
| :---    | :----    | :---    |
| terraform plan | Gerenciamento | -- |

---

### 3. Apply

| Sintaxe  | Contexto | Descrição |
| :---    | :----    | :---    |
| terraform apply | Implantação | Executa a aplicação dos recursos declarados na configuração, implementando mudanças necessárias. É recomendável consultar o `plan` antes de confirmar.  |
| terraform apply -auto-approve | Implantação | Aplica automaticamente os recursos declarados, sem solicitação de confirmação. Ideal para automação, mas é essencial revisar o `plan` antes para evitar erros. |
