#!/bin/bash
# Script simples para baixar um vídeo do YouTube, extrair o áudio
# e embutir legendas em formato ASS.
# Uso: ./embed_lyrics.sh URL_DO_VIDEO caminho_para_ass

set -e

VIDEO_URL="$1"
ASS_FILE="$2"

if [ -z "$VIDEO_URL" ] || [ -z "$ASS_FILE" ]; then
  echo "Uso: $0 URL_DO_VIDEO arquivo.ass" >&2
  exit 1
fi

if ! command -v yt-dlp >/dev/null || ! command -v ffmpeg >/dev/null; then
  echo "Erro: yt-dlp e ffmpeg precisam estar instalados." >&2
  exit 1
fi

BASENAME="video"

yt-dlp "$VIDEO_URL" -o "$BASENAME.mp4"

ffmpeg -i "$BASENAME.mp4" -vn -q:a 0 -map a "$BASENAME.mp3"

ffmpeg -i "$BASENAME.mp4" -vf "ass=$ASS_FILE" -c:a copy "${BASENAME}_legendado.mp4"

echo "Arquivo gerado: ${BASENAME}_legendado.mp4"
