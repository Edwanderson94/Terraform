# Autenticacao local

Nao envie PATs, senhas, chaves privadas ou conteudo de arquivos de credencial
em chats, Git ou Trello. Armazene o PAT fora do repositorio, em um arquivo
local com permissao restrita:

```bash
mkdir -p ~/.config/tecnoform
chmod 700 ~/.config/tecnoform
${EDITOR:-vi} ~/.config/tecnoform/azure-devops.env
chmod 600 ~/.config/tecnoform/azure-devops.env
```

O arquivo deve conter somente:

```bash
export AZDO_ORG_SERVICE_URL='https://dev.azure.com/Tecnoform'
export AZDO_PERSONAL_ACCESS_TOKEN='cole-seu-pat-aqui'
```

Para carregamento opcional em shells Zsh, adicione manualmente a seguinte
linha ao final de `~/.zshrc`:

```bash
[[ -f ~/.config/tecnoform/azure-devops.env ]] && source ~/.config/tecnoform/azure-devops.env
```

Abra uma nova sessao ou execute `source ~/.zshrc`. Confirme apenas que a
variavel existe; nunca imprima seu valor:

```bash
[[ -n ${AZDO_PERSONAL_ACCESS_TOKEN:-} ]] && echo 'PAT configurado'
```
