# DePaula

Repositório com scripts e documentos de apoio.

## Conteúdo

- `docs/slipknot_legendagem_pt.md` – tutorial para baixar o clipe "The Devil In I" e embutir legendas.
- `scripts/embed_lyrics.sh` – automatiza o download do vídeo e a inclusão das legendas.
- `scripts/setup_win11_template.sh` – script auxiliar para iniciar a configuração de uma TemplateVM Windows 11 em Qubes OS.

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
