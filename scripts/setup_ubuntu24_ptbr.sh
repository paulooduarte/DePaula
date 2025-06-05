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

DIAG=false
UPLOAD=false
CHATGPT=false
for arg in "$@"; do
  case "$arg" in
    --diagnostic) DIAG=true ;;
    --upload-log) UPLOAD=true ;;
    --chatgpt) CHATGPT=true ;;
    *) echo "Uso: $0 [--diagnostic [--upload-log] [--chatgpt]]" >&2; exit 1 ;;
  esac
done

upload_log_github() {
  if [ -z "${GITHUB_TOKEN:-}" ]; then
    echo "Variável GITHUB_TOKEN não definida. Pulando envio ao GitHub."
    return
  fi

  local file="$1"
  local data
  data=$(printf '{"description":"Ubuntu setup diagnostic","public":false,"files":{"diagnostic.txt":{"content":"%s"}}}' "$(sed 's/"/\\"/g' "$file")")
  local resp
  resp=$(curl -fsS -H "Authorization: token $GITHUB_TOKEN" \
    -H "Content-Type: application/json" \
    -d "$data" https://api.github.com/gists)
  echo "Log enviado para: $(echo "$resp" | grep -o 'https://gist.github.com/[^"]*')"
}

chatgpt_feedback() {
  if [ -z "${OPENAI_API_KEY:-}" ]; then
    echo "Variável OPENAI_API_KEY não definida. Pulando consulta ao ChatGPT."
    return
  fi

  local file="$1"
  local prompt
  prompt=$(sed 's/"/\\"/g' "$file")
  local payload
  payload=$(printf '{"model":"gpt-3.5-turbo","messages":[{"role":"user","content":"Analise o seguinte log e indique possiveis solucoes:\n%s"}]}' "$prompt")
  local resp
  resp=$(curl -fsS https://api.openai.com/v1/chat/completions \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $OPENAI_API_KEY" \
    -d "$payload")
  echo "ChatGPT: $(echo "$resp" | grep -o '"content":"[^"]*"' | sed 's/"content":"\(.*\)"/\1/' | sed 's/\\n/\n/g')"
}

diagnostic_log="/tmp/diagnostic.log"
if $DIAG; then
  run_diagnostic | tee "$diagnostic_log"
  $UPLOAD && upload_log_github "$diagnostic_log"
  $CHATGPT && chatgpt_feedback "$diagnostic_log"
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
