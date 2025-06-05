# Template Windows 11 no Qubes OS

Este documento descreve como criar um TemplateVM do Windows 11 e prepará-lo para uso no Qubes OS com base no Fedora. Os passos devem ser executados em **dom0**.

## Pré-requisitos

1. ISO oficial do Windows 11 copiada para dom0 ou acessível via dispositivo USB.
2. Espaço em disco suficiente (recomenda-se ao menos 40 GB).
3. Mídia com Qubes Windows Tools (QWT) para integração.

Antes de prosseguir, certifique-se de que está no **dom0** do Qubes OS e que possuí privilégios de administrador. Os comandos `qvm-*` devem estar disponíveis.

## Passo a passo

Se preferir automatizar parte do processo, utilize o script `scripts/setup_win11_template.sh` deste repositório:
```bash
chmod +x scripts/setup_win11_template.sh
sudo bash scripts/setup_win11_template.sh /caminho/para/Win11.iso
```
O script cria o TemplateVM com as configurações sugeridas e inicia a instalação do Windows.

Se optar por executar os comandos manualmente, siga as etapas abaixo.

1. **Criar o TemplateVM**
   ```bash
   qvm-create --class TemplateVM --label red win11-template
   qvm-prefs win11-template virt_mode hvm
   qvm-prefs win11-template kernel ""
   qvm-volume resize win11-template:root 40g
   qvm-prefs win11-template memory 4096
   ```
2. **Iniciar instalação a partir da ISO**
   ```bash
   qvm-start win11-template --cdrom=/caminho/para/Win11.iso
   ```
   Siga o processo padrão de instalação do Windows 11 até sua conclusão.

3. **Instalar Qubes Windows Tools**
   Após concluir a instalação do Windows, monte a mídia do QWT e execute o instalador dentro do Windows. Reinicie o sistema quando solicitado.

4. **Criar uma AppVM baseada no template**
   ```bash
   qvm-create --class AppVM --label blue --template win11-template win11-appvm
   ```
   A partir de agora, `win11-appvm` pode ser iniciado normalmente pelo gestor de qubes.

## Observações

- Algumas etapas, como o processo interativo de instalação do Windows, não são automatizáveis e exigem intervenção manual.
- Consulte a [documentação oficial](https://www.qubes-os.org/doc/templates/windows/) para detalhes adicionais e atualizações.
