#!/bin/bash
# Script simples para baixar um vídeo do YouTube (ou usar um arquivo local),
# extrair o áudio e embutir legendas em formato ASS.
# Uso: ./embed_lyrics.sh <URL|arquivo.mp4> caminho_para_ass


set -e

VIDEO_SRC="$1"
ASS_FILE="$2"

if [ -z "$VIDEO_SRC" ] || [ -z "$ASS_FILE" ]; then
  echo "Uso: $0 <URL|arquivo.mp4> arquivo.ass" >&2
  exit 1
fi

if ! command -v ffmpeg >/dev/null; then
  echo "Erro: ffmpeg precisa estar instalado." >&2
  exit 1
fi

DOWNLOAD_REQUIRED=0
if [[ "$VIDEO_SRC" =~ ^https?:// ]]; then
  DOWNLOAD_REQUIRED=1
  if ! command -v yt-dlp >/dev/null; then
    echo "Erro: yt-dlp precisa estar instalado para baixar vídeos." >&2
    exit 1
  fi
fi

BASENAME="video"

if [ "$DOWNLOAD_REQUIRED" -eq 1 ]; then
  yt-dlp "$VIDEO_SRC" -o "$BASENAME.mp4"
else
  cp "$VIDEO_SRC" "$BASENAME.mp4"
fi

ffmpeg -i "$BASENAME.mp4" -vn -q:a 0 -map a "$BASENAME.mp3"

ffmpeg -i "$BASENAME.mp4" -vf "ass=$ASS_FILE" -c:a copy "${BASENAME}_legendado.mp4"

echo "Arquivo gerado: ${BASENAME}_legendado.mp4"
