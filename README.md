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
