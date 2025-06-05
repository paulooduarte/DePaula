#!/bin/bash
# Script para configurar automaticamente o Ubuntu 24.04 em português do Brasil,
# instalar aplicativos úteis e realizar um diagnóstico básico do sistema.

set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
  echo "Erro: execute como root." >&2
  exit 1
fi

run_diagnostic() {
  echo "==> Verificando conectividade"
  if ! ping -c1 8.8.8.8 >/dev/null 2>&1; then
    echo "Sem acesso à internet" >&2
  else
    echo "Conexão OK"
  fi

  echo "==> Corrigindo pacotes quebrados"
  dpkg --configure -a
  apt-get -f install -y
  apt-get update
  apt-get upgrade -y
  apt-get autoremove -y
}

if [[ "${1:-}" == "--diagnostic" ]]; then
  run_diagnostic
  echo "Diagnóstico finalizado"
  exit 0
fi

# Configura locale e timezone
locale-gen pt_BR.UTF-8
update-locale LANG=pt_BR.UTF-8
localectl set-locale LANG=pt_BR.UTF-8

timedatectl set-timezone America/Sao_Paulo

# Atualiza sistema
apt-get update
apt-get upgrade -y

# Brave browser
if [ ! -f /usr/share/keyrings/brave-browser-archive-keyring.gpg ]; then
  curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" \
    > /etc/apt/sources.list.d/brave-browser-release.list
fi

# OBS Studio
apt-get install -y software-properties-common
add-apt-repository -y ppa:obsproject/obs-studio

apt-get update

# Instala pacotes
apt-get install -y brave-browser telegram-desktop obs-studio gnome-tweaks

# Limpeza
apt-get autoremove -y

printf '\nConfiguração concluída. Reinicie para aplicar todas as configurações.\n'
