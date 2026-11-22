# Como guardar o instalador no seu GitHub

Repositório: https://github.com/SavimaleDEV/xui-one-atualizado

O repositório público contém `install.sh` e documentação. O ZIP completo fica como arquivo de uma Release. O GitHub bloqueia arquivos acima de 100 MiB no Git comum, mas permite assets de Release abaixo de 2 GiB: [limites de arquivos](https://docs.github.com/en/repositories/working-with-files/managing-large-files/about-large-files-on-github), [Releases](https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases).

## Trocar de máquina

Em um Ubuntu 20.04, 22.04 ou 24.04 x86_64 novo:

```bash
wget https://raw.githubusercontent.com/SavimaleDEV/xui-one-atualizado/main/install.sh -O install.sh
sudo bash install.sh
```

Não precisa autenticar no GitHub. O script traz a Release pública, confere o manifesto fixado e instala o nosso pacote completo. A migração dos dados do servidor antigo é uma tarefa separada.

## Criar outro repositório pelo navegador

1. No GitHub clique em **New repository**.
2. Escolha nome, por exemplo `xui-one-atualizado`, e visibilidade **Public**.
3. Envie `install.sh` e `README.md` pelo botão **Add file → Upload files**. Não envie o ZIP grande pelo Git comum.
4. Vá a **Releases → Draft a new release**.
5. Crie a tag `v1.5.12-update-20261122`, anexe `XUI_1.5.12_COMPLETO.zip` e seu `.sha256` e publique.
6. Para outro usuário/nome de repositório, altere `XUI_REPOSITORY` no `install.sh` e os links do README.

## Atualizar esta cópia no futuro

Faça as mudanças e testes localmente primeiro. Gere novo `instalador/SHA256SUMS`; atualize `MANIFEST_SHA256` no `install.sh` com o hash desse manifesto. Publique uma nova tag/asset e ajuste `XUI_RELEASE_TAG` no script. Cada script fica preso aos arquivos conferidos daquela versão.

Exemplo usando GitHub CLI já autenticado:

```bash
gh repo clone SavimaleDEV/xui-one-atualizado
cd xui-one-atualizado
# Copie para aqui o novo install.sh e a documentação.
git add install.sh README.md COMO_USAR_GITHUB.md
git commit -m "Atualiza instalador XUI 1.5.12"
git push
# Use um novo nome de tag para cada versão.
gh release create NOVA_TAG /caminho/XUI_1.5.12_COMPLETO.zip /caminho/XUI_1.5.12_COMPLETO.zip.sha256 --title "XUI 1.5.12 atualizado" --notes "Instalador completo com atualizações."
```

A pasta `github/` é a cópia pequena preparada para Git. A pasta `para-transferir/` guarda o ZIP que deve ser anexado à Release. O pacote não contém tokens do GitHub nem credenciais de produção.
