# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

# Tema custom (desabilitou OMZ themes)
# ZSH_THEME=""
ZSH_THEME="powerlevel10k/powerlevel10k"

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
##eval "$(starship init zsh)"

eval "$(atuin init zsh)"

# Desativa XOFF (Ctrl+S pausa terminal acidentalmente)
[[ -o interactive ]] && stty -ixon

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source <(fzf --zsh)

# Run startup tools
[[ -o interactive ]] && command -v fastfetch &>/dev/null && fastfetch
[[ -o interactive ]] && command -v fortune &>/dev/null && command -v cowsay &>/dev/null && fortune | cowsay

# zoxide precisa ser inicializado no final do arquivo
eval "$(zoxide init zsh)"
