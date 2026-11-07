#!/usr/bin/env bash
# Depois que o herdr restaura a sessão no arranque, abre o btop na aba 3 do
# workspace ERIC. O herdr já devolve o layout, os diretórios e (com a integração
# do Claude instalada) as sessões do claude, mas não relança outros programas.

workspace_label="ERIC"
tab_label="3"
command="btop"

# Espera o servidor do herdr subir e restaurar o workspace (até 60 s).
for _ in $(seq 120); do
  ws_id=$(herdr workspace list 2>/dev/null |
    jq -r --arg l "$workspace_label" '.result.workspaces[] | select(.label == $l) | .workspace_id' | head -1)
  [[ -n $ws_id ]] && break
  sleep 0.5
done
[[ -z $ws_id ]] && exit 1

tab_id=$(herdr tab list --workspace "$ws_id" |
  jq -r --arg l "$tab_label" '.result.tabs[] | select(.label == $l) | .tab_id')
[[ -z $tab_id ]] && exit 1

pane=$(herdr pane list | jq -r --arg t "$tab_id" '[.result.panes[] | select(.tab_id == $t)][0]')
pane_id=$(jq -r '.pane_id' <<<"$pane")

# Só roda se a aba ainda estiver num shell (não abre um segundo btop).
title=$(jq -r '.terminal_title_stripped // ""' <<<"$pane")
[[ $title == *"$command"* ]] && exit 0

sleep 1   # dá tempo do shell da aba terminar de carregar o .zshrc
herdr pane run "$pane_id" "$command"
