# zsh/omarchy.zsh
# Integração com o Omarchy (equivalente ao que o ~/.bashrc do Omarchy faz no bash).
# Só roda em máquinas com Omarchy.
[[ -r /usr/share/omarchy/default/bash/env-bootstrap ]] || return 0

# OMARCHY_PATH + PATH (shims do mise, ~/.local/bin)
source /usr/share/omarchy/default/bash/env-bootstrap

export BROWSER="${BROWSER:-omarchy-launch-browser}"
export BAT_THEME=ansi
export MANROFFOPT="-c"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Versões de linguagens (substitui o asdf; lê o ~/.tool-versions)
command -v mise &>/dev/null && eval "$(mise activate zsh)"

# Atalhos úteis do Omarchy
open() { xdg-open "$@" >/dev/null 2>&1 & }
alias t='tmux attach || tmux new -s Work'
alias lt='eza --tree --level=2 --long --icons --git'
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"

# Agente SSH do systemd (ssh-agent.socket); a sessão gráfica já define isso via ~/.config/uwsm/env
[[ -z $SSH_AUTH_SOCK ]] && export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
