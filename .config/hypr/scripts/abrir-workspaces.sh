#!/usr/bin/env bash
# Abre os apps do dia a dia e põe cada um no seu workspace, só no arranque.
# Depois disso, janelas novas abrem no workspace onde você estiver.
# Ímpares = notebook (eDP-1), pares = HP V28 (HDMI-A-1); ver monitors.lua.
#
# Os apps abrem um de cada vez: o script espera a janela nova de cada um aparecer
# e a move. Assim dá para separar janelas de mesma classe, como os perfis do
# Chrome (todos têm a classe google-chrome).

# workspace ; classe da janela (regex) ; comando
apps=(
  "1;^herdr$;foot --app-id=herdr herdr"
  "2;^brave-browser$;brave"
  "3;^[Gg]oogle-chrome$;google-chrome-stable --profile-directory=Default"      # ericsts@gmail.com
  "3;^[Gg]oogle-chrome$;google-chrome-stable --profile-directory=Profile 4"    # ericsts.web@gmail.com
  "4;^[Ss]lack$;slack"
  "4;^[Gg]oogle-chrome$;google-chrome-stable --profile-directory=Profile 1"    # paymetrust.net
  "5;^[Gg]oogle-chrome$;google-chrome-stable --profile-directory=Profile 2"    # Emagine
  "5;^signal$;signal-desktop"
)

declare -A seen

# Marca as janelas que já existem, para só mexer nas que este script abrir.
while read -r addr; do seen[$addr]=1; done < <(hyprctl clients -j | jq -r '.[].address')

# Espera (até 40 s) uma janela nova da classe e a move para o workspace.
wait_and_move() {
  local ws=$1 pattern=$2 addr cls
  for _ in $(seq 80); do
    while read -r addr cls; do
      [[ -n ${seen[$addr]} ]] && continue
      if [[ $cls =~ $pattern ]]; then
        seen[$addr]=1
        hyprctl dispatch "hl.dsp.window.move({ workspace = \"$ws\", window = \"address:$addr\", follow = false })" >/dev/null
        return 0
      fi
    done < <(hyprctl clients -j | jq -r '.[] | "\(.address) \(.class)"')
    sleep 0.5
  done
  return 1
}

for entry in "${apps[@]}"; do
  IFS=';' read -r ws pattern cmd <<<"$entry"
  # --profile-directory=Profile 4 tem espaço: o valor vai inteiro como um argumento.
  if [[ $cmd == *"--profile-directory="* ]]; then
    uwsm-app -- "${cmd%% *}" "--profile-directory=${cmd#*--profile-directory=}" >/dev/null 2>&1 &
  else
    uwsm-app -- $cmd >/dev/null 2>&1 &
  fi
  wait_and_move "$ws" "$pattern"
done

# Notebook no ws 1, HP no ws 2.
hyprctl dispatch 'hl.dsp.focus({ workspace = "2" })' >/dev/null
hyprctl dispatch 'hl.dsp.focus({ workspace = "1" })' >/dev/null
