alias gst="git status"
alias gl="git pull"
alias gp="git push"
alias gpf="git push --force-with-lease"
alias gcm="git commit -m"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gd="git diff"
alias gaa="git add --all"
alias gc="git commit"

# Open changed file preview w/ fzf
gfe() {
  git ls-files -m | fzf --preview 'git diff --color=always {}' | xargs -r $EDITOR
}

