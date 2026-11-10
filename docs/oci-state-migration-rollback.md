# Runbook de migração e rollback do state OCI

Este runbook deve ser aprovado antes de qualquer `terraform init
-migrate-state`, `apply` ou ativação do provisionamento concorrente. Ele trata
da camada
`azure-devops/organizations/Tecnoform/projects/infraestructure`, cujo state
atual ainda é local.

## Pré-condições e decisão de mudança

1. Confirmar o compartment, o bucket privado, o namespace e a região OCI.
2. Confirmar que o bucket está versionado e que a identidade da pipeline tem
   somente acesso ao bucket-alvo.
3. Confirmar que o backend `oci` está declarado na configuração efetivamente
   usada pelo stack. A variável `OCI_TF_STATE_MIGRATED` sozinha não substitui a
   configuração do backend.
4. Confirmar o Variable Group, Secure File e Environment protegidos no Azure
   DevOps; nenhum segredo pode estar no repositório ou em artefatos.
5. Definir uma janela de mudança e impedir qualquer outro `plan`, `apply` ou
   alteração local no stack durante a migração.
6. Obter aprovação registrada para o plano, o backup e o procedimento de
   recuperação.

Se qualquer pré-condição falhar, interromper antes de alterar state.

## Backup durável antes da migração

O backup deve ser criado em armazenamento externo ao workspace e fora do Git.
Use uma máquina sob controle da equipe de infraestrutura, com acesso restrito,
criptografia em repouso e retenção definida pela política da organização.

No diretório do stack, registrar apenas metadados não sensíveis do backup, como
data, commit e hash do arquivo. Não registrar o conteúdo do state, valores de
recursos ou credenciais.

```bash
cd azure-devops/organizations/Tecnoform/projects/infraestructure
terragrunt init -backend=false
terragrunt state pull > /caminho/externo/terraform.tfstate.backup.json
openssl dgst -sha256 /caminho/externo/terraform.tfstate.backup.json
```

O arquivo deve ser cifrado e armazenado antes de continuar. Após cifrar, validar
que a cópia pode ser descriptografada em uma área temporária protegida e que o
JSON é legível. Remover cópias temporárias e não executar esses comandos em um
runner hospedado sem armazenamento persistente e protegido.

## Plan e migração

1. Revisar o `terraform plan` com o backend ainda local e registrar o resultado
   esperado. Não aceitar creates, updates ou destroys inesperados.
2. Confirmar novamente o backup e a aprovação.
3. Configurar as variáveis OCI exclusivamente no ambiente protegido.
4. Executar a migração em uma estação persistente e controlada:

   ```bash
   terragrunt init -migrate-state
   ```

   Não usar `-force-copy`. Se o Terraform pedir confirmação, interromper para
   revisar a origem, o destino e a cópia de segurança antes de confirmar.
5. Verificar que o backend efetivo é `oci` e que o state foi lido do destino:

   ```bash
   terragrunt state pull > /tmp/terraform-state-after-migration.json
   terragrunt plan -detailed-exitcode
   ```

   O arquivo temporário não deve ser publicado nem commitado; removê-lo após a
   comparação protegida com o backup.

## Teste de locking e recuperação

Antes de habilitar qualquer pipeline concorrente:

1. Iniciar um `plan` controlado com a primeira sessão.
2. Iniciar um segundo `plan` no mesmo stack e confirmar que o backend impede a
   concorrência ou aguarda o lock, sem criar dois writers simultâneos.
3. Encerrar a sessão de teste de forma normal e confirmar que o lock foi
   liberado.
4. Testar a restauração do backup em um workspace isolado, sem apontar para a
   produção e sem sobrescrever o state remoto.
5. Registrar evidência do teste, o operador, o horário e a decisão de liberar ou
   não o pipeline.

O lock do backend OCI e o `concurrency`/exclusive lock da pipeline são controles
complementares. Um não substitui o outro.

## Rollback

### Falha antes da migração

Manter o state local intacto, corrigir a causa e repetir o procedimento somente
após uma nova revisão. Não apagar o backup.

### Falha durante `init -migrate-state`

Interromper o pipeline, preservar logs sem segredos, verificar a versão do
bucket e consultar o backup externo. Não usar `-force-copy` nem executar um
segundo migrate às cegas. A decisão de repetir ou restaurar deve ser aprovada.

### Falha depois da migração

Bloquear novos writers, confirmar qual versão do objeto remoto é a última
íntegra e restaurar somente após aprovação. Se for necessário voltar ao state
local, usar uma cópia descriptografada temporária e controlada, revisar o plano
resultante e nunca substituir o state remoto sem uma decisão formal de rollback.

Depois de qualquer rollback, executar novamente o teste de leitura, plan,
locking e recuperação antes de reabilitar a pipeline.

## Critérios para habilitar a pipeline

Habilitar `OCI_TF_STATE_MIGRATED=true` e o apply protegido somente quando todos
os itens abaixo tiverem evidência:

- backup externo criptografado validado;
- migração concluída sem impacto inesperado;
- state remoto lido com sucesso;
- teste de locking e concorrência aprovado;
- restauração validada em ambiente isolado;
- Environment com aprovação e exclusive lock configurado;
- plan revisado para o commit que será aplicado.

Enquanto um item estiver pendente, a pipeline deve continuar limitada a
validação e plan, sem `apply` automático.
