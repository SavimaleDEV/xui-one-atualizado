# XUI 1.5.12 com crack, otimizações e Mass Edit

Instalação em **Ubuntu 20.04, 22.04 ou 24.04 x86_64**, com systemd e mínimo de 4 GiB RAM. Use um servidor novo e dedicado.

## Instalar pelo GitHub

```bash
wget https://raw.githubusercontent.com/SavimaleDEV/xui-one-atualizado/main/install.sh -O install.sh
sudo bash install.sh
```

O script baixa nosso pacote da Release pública e confere seus arquivos antes de executar a instalação. Não precisa de conta ou token do GitHub na máquina nova.

## Instalar usando a pasta completa

Copie esta pasta ou extraia `XUI_1.5.12_COMPLETO.zip` no servidor e execute:

```bash
sudo bash install.sh
```

Para conferir o pacote sem instalar:

```bash
bash install.sh --check
```

O fluxo instala dependências, XUI 1.5.12, crack e nossas atualizações. Aplica tudo antes do primeiro início. O endereço do painel aparece no final; credenciais do banco ficam em `/root/xui-install-credentials.txt`.

No Ubuntu 22.04/24.04, o instalador adapta Nginx/RTMP e bibliotecas de compatibilidade para o PHP 7.4 fornecido. O payload XUI e o SQL originais são preservados.

## Mass Edit

Troca SET SERVERS, somente a opção Servidores e um destino. Com restart: 2 canais por grupo, aguardando funcionamento estável. Sem restart: 25 associações por grupo. Mantenha a página aberta; recarregar retoma o acompanhamento. Não há reenvio automático de lotes sem confirmação. A fila controla o ritmo de abertura; a capacidade depende do servidor e das fontes.

## Arquivos

- `install.sh`: entrada única, local ou via GitHub.
- `instalador/`: sistema, componentes e atualizações.
- `instalador/LEIA-ME.txt`: detalhes de instalação/manutenção.
- `instalador/VALIDACAO.txt`: testes e limites.
- `COMO_USAR_GITHUB.md`: como guardar/publicar uma versão própria.
- `referencia/`: scripts recebidos dos repositórios de referência, guardados sem execução.

Os testes isolados das três distribuições passaram. Ainda falta validar boot completo e configuração final do painel em VMs novas. Não foram incluídos banco, credenciais ou acesso ao servidor em produção.

Referências do formato do instalador: [PabloServers](https://github.com/PabloServers/xui.one) e [amidevous](https://github.com/amidevous/xui.one). Esta versão usa o nosso pacote 1.5.12 e não segue downloads mutáveis de outra versão do XUI.
