#!/usr/bin/env bash
# Tela cheia só no Hyprland (a janela ocupa o monitor inteiro), sem avisar o app.
# Assim o Brave/Chrome não entram no modo F11 e as abas continuam visíveis.

state=$(hyprctl activewindow -j | jq -r '.fullscreen // 0')

if [[ $state == "2" ]]; then
  hyprctl dispatch 'hl.dsp.window.fullscreen_state({ internal = 0, client = 0 })' >/dev/null
else
  hyprctl dispatch 'hl.dsp.window.fullscreen_state({ internal = 2, client = 0 })' >/dev/null
fi
