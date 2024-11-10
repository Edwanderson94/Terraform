# Terraform - Lista de Comandos

---

### 1. Init

| Sintaxe  | Contexto | Descrição |
| :---    | :----    | :---    |
| kubectl cluster-info | Gerenciamento | Fornece informações sobre os serviços principais que estão sendo executados no cluster |
| kubectl get all | Gerenciamento | Lista todos os recursos principais (como Pods, Services, Deployments, ReplicaSets, etc.) no namespace atual do cluster Kubernetes. |

### 2. Plan

| Sintaxe  | Contexto | Descrição |
| :---    | :----    | :---    |
| kubectl cluster-info | Gerenciamento | Fornece informações sobre os serviços principais que estão sendo executados no cluster |


### 3. Apply

| Sintaxe  | Contexto | Descrição |
| :---    | :----    | :---    |
| terraform apply | Implantação | Executa a aplicação dos recursos declarados na configuração, implementando mudanças necessárias. É recomendável consultar o `plan` antes de confirmar.  |
| terraform apply -auto-approve | Implantação | Aplica automaticamente os recursos declarados, sem solicitação de confirmação. Ideal para automação, mas é essencial revisar o `plan` antes para evitar erros. |
