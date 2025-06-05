#!/bin/bash
# Script para configurar automaticamente o Ubuntu 24.04 em português do Brasil e instalar aplicativos úteis.

set -e

if [ "$(id -u)" -ne 0 ]; then
  echo "Erro: execute como root." >&2
  exit 1
fi

# Configura locale e timezone
locale-gen pt_BR.UTF-8
update-locale LANG=pt_BR.UTF-8
localectl set-locale LANG=pt_BR.UTF-8

timedatectl set-timezone America/Sao_Paulo

# Atualiza sistema
apt update
apt -y upgrade

# Brave browser
if [ ! -f /usr/share/keyrings/brave-browser-archive-keyring.gpg ]; then
  curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" \
    > /etc/apt/sources.list.d/brave-browser-release.list
fi

# OBS Studio
apt-get install -y software-properties-common
add-apt-repository -y ppa:obsproject/obs-studio

apt update

# Instala pacotes
apt install -y brave-browser telegram-desktop obs-studio gnome-tweaks

# Limpeza
apt autoremove -y

printf '\nConfiguração concluída. Reinicie para aplicar todas as configurações.\n'
