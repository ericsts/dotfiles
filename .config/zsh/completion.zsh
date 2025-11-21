# zsh/completion.zsh
# Enable completion
autoload -Uz compinit

# Adiciona pasta de completions customizados
fpath=(~/.config/zsh/completions $fpath)

compinit

# Melhorias de completion
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=** r:|=**'
