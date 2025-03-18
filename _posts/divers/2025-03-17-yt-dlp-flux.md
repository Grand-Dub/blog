---
title: Téléchargement d'une vidéo qui a plusieurs formats (comme sur Arte.tv) avec yt-dlp
date: 2025-03-18
category: Divers
layout: post
description: Téléchargement d'une vidéo qui a plusieurs formats (comme sur Arte.tv) avec yt-dlp
---


**Ici avec l'exemple du téléchargement du film "Les Arnaqueurs" sur "Arte.tv"**

L'URL de téléchargement est : `https://manifest-arte.akamaized.net/api/manifest/v1/Generate/f05244a1-ad5b-415b-89f6-b8ffc8b094ec/fr/XQ+KS+CHEV1/037265-000-B.m3u8` (cette URL est valide le 2025-03-17 mais cette URL finira par ne plus exister)

Le téléchargement de l'URL avec `yt-dlp` me donne, par défaut, la version française avec l'audiodescription ! (l’audiodescription ne m’intéresse pas, mais ceux que ça intéresse peuvent adapter la suite)

> **Affichage des formats disponibles :**
```sh
url='https://manifest-arte.akamaized.net/api/manifest/v1/Generate/f05244a1-ad5b-415b-89f6-b8ffc8b094ec/fr/XQ+KS+CHEV1/037265-000-B.m3u8'
yt-dlp "$url" --list-formats
```
```
[generic] Extracting URL: https://manifest-arte.akamaized.net/api/manifest/v1/Generate/f05244a1-ad5b-415b-89f6-b8ffc8b094ec...V1/037265-000-B.m3u8
[generic] 037265-000-B: Downloading webpage
[generic] 037265-000-B: Downloading m3u8 information
[generic] 037265-000-B: Checking m3u8 live status
[info] Available formats for 037265-000-B:
ID                                  EXT RESOLUTION FPS │   FILESIZE   TBR PROTO │ VCODEC          VBR ACODEC     MORE INFO
─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
audio_0-Allemand                    mp4 audio only     │                  m3u8  │ audio only          unknown    [de] Allemand
audio_0-Allemand__audiodescription_ mp4 audio only     │                  m3u8  │ audio only          unknown    [de] Allemand (audiodescription)
audio_0-Anglais__Original_          mp4 audio only     │                  m3u8  │ audio only          unknown    [en] Anglais (Original)
audio_0-Français                    mp4 audio only     │                  m3u8  │ audio only          unknown    [fr] Français
audio_0-Français__audiodescription_ mp4 audio only     │                  m3u8  │ audio only          unknown    [fr] Français (audiodescription)
425                                 mp4 384x216     25 │ ~317.65MiB  426k m3u8  │ avc1.42e00d    426k video only
723                                 mp4 640x360     25 │ ~539.47MiB  723k m3u8  │ avc1.4d401e    723k video only
1120                                mp4 768x432     25 │ ~835.71MiB 1120k m3u8  │ avc1.4d401e   1120k video only
1915                                mp4 1280x720    25 │ ~  1.40GiB 1915k m3u8  │ avc1.4d401f   1915k video only
1917                                mp4 1280x720    25 │ ~  1.40GiB 1918k m3u8  │ hev1.2.4.L120 1918k video only
2149                                mp4 1920x1080   25 │ ~  1.57GiB 2149k m3u8  │ avc1.4d0028   2149k video only
2150                                mp4 1920x1080   25 │ ~  1.57GiB 2150k m3u8  │ hev1.2.4.L123 2150k video only
```

Donc,ici, pour télécharger le format qui me convient : 
```sh
yt-dlp "$url" -f "audio_0-Français+2150" --merge-output-format mp4
```
