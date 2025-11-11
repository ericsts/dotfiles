export ZSH="$HOME/.oh-my-zsh"

# Tema custom (desabilitou OMZ themes)
# ZSH_THEME=""

# EZA styles
zstyle ':omz:plugins:eza' 'dirs-first' yes
zstyle ':omz:plugins:eza' 'git-status' yes
zstyle ':omz:plugins:eza' 'header' yes
zstyle ':omz:plugins:eza' 'icons' yes
zstyle ':omz:plugins:eza' 'color-scale' all 
zstyle ':omz:plugins:eza' 'color-scale-mode' gradient
zstyle ':omz:plugins:eza' 'size-prefix' binary
zstyle ':omz:plugins:eza' 'hyperlink' yes

# Sourcing configs
for file in ~/.config/zsh/*.zsh; do
  source "$file"
done

# Starship
eval "$(starship init zsh)"

eval "$(atuin init zsh)"

# Run startup tools
fastfetch
fortune | cowsay
