# Legendagem de "Slipknot - The Devil In I" para VLC

Este guia descreve como baixar o vídeo oficial, extrair o áudio e embutir legendas sincronizadas utilizando o Ubuntu 24.04.

## 1. Instale dependências

```bash
sudo apt update
sudo apt install ffmpeg yt-dlp
```

## 2. Baixe o vídeo

Substitua `URL_DO_VIDEO` pelo endereço do clipe (ex: `https://www.youtube.com/watch?v=XEEasR7hVhA`).

```bash
yt-dlp URL_DO_VIDEO -o slipknot.mp4
```

## 3. Extraia o áudio

```bash
ffmpeg -i slipknot.mp4 -vn -q:a 0 -map a slipknot.mp3
```

## 4. Crie o arquivo de legendas

Use o formato ASS para personalizar cor de fundo e bordas. Crie `slipknot.ass` com o conteúdo abaixo e complete as linhas restantes com os tempos corretos da música.

```ass
[Script Info]
ScriptType: v4.00+

[V4+ Styles]
Format: Name, Fontname, Fontsize, PrimaryColour, SecondaryColour, OutlineColour, BackColour, Bold, Italic, Underline, StrikeOut, ScaleX, ScaleY, Spacing, Angle, BorderStyle, Outline, Shadow, Alignment, MarginL, MarginR, MarginV, Encoding
Style: Default,Arial,36,&H00FFFFFF,&H00FFFFFF,&H00000000,&H007F5F00,0,0,0,0,100,100,0,0,1,2,0,2,10,10,20,1

[Events]
Format: Layer, Start, End, Style, Name, MarginL, MarginR, MarginV, Effect, Text
Dialogue: 0,0:00:14.00,0:00:19.00,Default,,0,0,0,,Undo these chains, my friend
```

*Acrescente as demais linhas com as letras completas seguindo a mesma estrutura.*

## 5. Embuta as legendas no vídeo

```bash
ffmpeg -i slipknot.mp4 -vf "ass=slipknot.ass" -c:a copy slipknot_legendado.mp4
```

Reproduza `slipknot_legendado.mp4` no VLC. O fundo das legendas será amarelo escuro e a borda preta, mantendo o áudio original.
