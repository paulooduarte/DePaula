#!/bin/bash
# Script para auxiliar a criação de um TemplateVM Windows 11 no Qubes OS.
# Execute em dom0 com privilégio de administrador.

set -e

if ! command -v qvm-create >/dev/null; then
  echo "Erro: comandos qvm-* indisponíveis. Execute em dom0 do Qubes OS." >&2
  exit 1
fi

if [ "$(id -u)" -ne 0 ]; then
  echo "Erro: é necessário executar como root em dom0." >&2
  exit 1
fi

TEMPLATE_NAME="win11-template"
ISO_PATH="$1"

if [ -z "$ISO_PATH" ]; then
  echo "Uso: $0 /caminho/para/Win11.iso"
  exit 1
fi

# Cria o TemplateVM
qvm-create --class TemplateVM --label red "$TEMPLATE_NAME"
qvm-prefs "$TEMPLATE_NAME" virt_mode hvm
qvm-prefs "$TEMPLATE_NAME" kernel ""
qvm-volume resize "$TEMPLATE_NAME":root 40g
qvm-prefs "$TEMPLATE_NAME" memory 4096

# Inicia instalação
qvm-start "$TEMPLATE_NAME" --cdrom="$ISO_PATH"

echo "Siga a instalação do Windows 11 na janela aberta."
echo "Após concluir, instale o Qubes Windows Tools manualmente."
echo "Em seguida, você pode criar uma AppVM baseada no template:" 
echo "  qvm-create --class AppVM --label blue --template $TEMPLATE_NAME win11-appvm"
