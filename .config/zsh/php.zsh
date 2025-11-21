# zsh/php.zsh
alias pa="php artisan"
alias sail='[ -f sail ] && bash sail || bash vendor/bin/sail'
alias pint="./vendor/bin/pint"

pint-staged() {
  local files=$(git diff --name-only --cached --diff-filter=ACM | grep -E '\.php$')
  [ -z "$files" ] && echo 'no staged PHP files' && return
  pint $files
}
