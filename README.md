# DePaula

Repositório com scripts e documentos de apoio.

## Conteúdo

- `docs/windows11_qubes_template_pt.md` – guia em português para criação de um TemplateVM do Windows 11 no Qubes OS.
- `scripts/setup_win11_template.sh` – script auxiliar para iniciar a configuração. Execute-o em **dom0** com privilégio de administrador e indicando a ISO do Windows 11.

## Uso rápido

1. Clone este repositório em dom0:
   ```bash
   git clone https://github.com/paulooduarte/DePaula.git
   cd DePaula
   ```
2. Dê permissão de execução ao script:
   ```bash
   chmod +x scripts/setup_win11_template.sh
   ```
3. Execute o script como root em dom0, fornecendo o caminho para a ISO do Windows 11:
   ```bash
   sudo bash scripts/setup_win11_template.sh /caminho/para/Win11.iso
   ```
   O script verifica a disponibilidade dos comandos `qvm-*` antes de iniciar e cria o TemplateVM com as configurações recomendadas.

Para mais detalhes, consulte `docs/windows11_qubes_template_pt.md`.

### Configuração rápida do Ubuntu 24.04

Para preparar uma instalação do Ubuntu 24.04 totalmente em português do Brasil e com aplicativos úteis como Brave, Telegram e OBS Studio, utilize o script `scripts/setup_ubuntu24_ptbr.sh`.
Ele também possui um modo de diagnóstico para corrigir problemas comuns de pacotes.

1. Dê permissão de execução:
   ```bash
   chmod +x scripts/setup_ubuntu24_ptbr.sh
   ```
2. Execute como root:
   ```bash
   sudo bash scripts/setup_ubuntu24_ptbr.sh
   ```
   O script atualizará o sistema, configurará o locale para `pt_BR.UTF-8`, ajustará o fuso horário para São Paulo e instalará os programas indicados.

Se precisar apenas rodar um diagnóstico e tentar corrigir pacotes quebrados, utilize a opção `--diagnostic`. É possível também enviar o log para um Gist privado no GitHub ou pedir sugestões ao ChatGPT, definindo previamente as variáveis `GITHUB_TOKEN` e `OPENAI_API_KEY` e passando as opções `--upload-log` e `--chatgpt`:
   ```bash
   export GITHUB_TOKEN=seu_token_do_github
   export OPENAI_API_KEY=seu_token_openai
   sudo bash scripts/setup_ubuntu24_ptbr.sh --diagnostic --upload-log --chatgpt
   ```
