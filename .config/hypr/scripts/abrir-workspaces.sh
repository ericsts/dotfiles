#!/usr/bin/env bash
# Abre os apps do dia a dia e põe cada um no seu workspace, só no arranque.
# Depois disso, janelas novas abrem no workspace onde você estiver.
# Ímpares = notebook (eDP-1), pares = Samsung (HDMI-A-1); ver monitors.lua.

# workspace ; classe da janela (regex) ; comando
apps=(
#  "1;^org\.wezfurlong\.wezterm$;wezterm"
  "1;^nvim$;foot --app-id=nvim nvim"
  "2;^brave-browser$;brave"
#  "2;^(com\.microsoft\.VSCode|[Cc]ode)$;code"
  "3;^[Ss]lack$;slack"
  "4;^[Gg]oogle-chrome$;google-chrome-stable"
  "4;^foot$;foot"
  "5;^(sublime_text|subl)$;subl"
  "6;^chromium$;chromium"
)

declare -A done_addr

move_new_windows() {
  local addr cls entry ws pattern
  while read -r addr cls; do
    [[ -n ${done_addr[$addr]} ]] && continue
    for entry in "${apps[@]}"; do
      IFS=';' read -r ws pattern _ <<<"$entry"
      if [[ $cls =~ $pattern ]]; then
        hyprctl dispatch "hl.dsp.window.move({ workspace = \"$ws\", window = \"address:$addr\", follow = false })" >/dev/null
        done_addr[$addr]=1
        break
      fi
    done
  done < <(hyprctl clients -j | jq -r '.[] | "\(.address) \(.class)"')
}

for entry in "${apps[@]}"; do
  IFS=';' read -r _ _ cmd <<<"$entry"
  uwsm-app -- $cmd >/dev/null 2>&1 &
done

# Durante 40 s, move cada janela nova desses apps para o workspace certo.
for _ in $(seq 40); do
  sleep 1
  move_new_windows
done

# Notebook no ws 1, Samsung no ws 2.
hyprctl dispatch 'hl.dsp.focus({ workspace = "2" })' >/dev/null
hyprctl dispatch 'hl.dsp.focus({ workspace = "1" })' >/dev/null
