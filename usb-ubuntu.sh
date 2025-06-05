#!/bin/bash
# Script para criar pendrive bootavel com Ubuntu
set -e
ISO_URL="https://releases.ubuntu.com/24.04.2/ubuntu-24.04.2-desktop-amd64.iso?_gl=1*1ir3va3*_gcl_au*MTI3MjE2NDAzOS4xNzQ5MDkyOTQz"
ISO_PATH="/tmp/ubuntu.iso"

if [ "$EUID" -ne 0 ]; then
  echo "Este script precisa ser executado como root ou usando sudo." >&2
  exit 1
fi

echo "Procurando pendrive de ~59GB, 64GB ou 113GB..."
DEVICE=$(lsblk -dn -o NAME,SIZE,RM | awk '$3==1 && ($2 ~ /^59G$/ || $2 ~ /^64G$/ || $2 ~ /^113G$/){print $1; exit}')

if [ -z "$DEVICE" ]; then
  echo "Nenhum dispositivo compativel encontrado." >&2
  exit 1
fi

DEV_PATH="/dev/$DEVICE"
echo "Dispositivo encontrado: $DEV_PATH"
read -r -p "Todos os dados em $DEV_PATH serao apagados. Continuar? [s/N] " answer
if [[ "$answer" != "s" && "$answer" != "S" ]]; then
  echo "Operacao cancelada." >&2
  exit 1
fi

umount "${DEV_PATH}"?* 2>/dev/null || true

if [ ! -f "$ISO_PATH" ]; then
  echo "Baixando imagem do Ubuntu..."
  curl -L -o "$ISO_PATH" "$ISO_URL"
fi

echo "Gravando ISO em $DEV_PATH..."
dd if="$ISO_PATH" of="$DEV_PATH" bs=4M status=progress oflag=sync

echo "Concluido."
