alias d="docker"
alias dc="docker compose"
alias dip="docker image prune -f"
alias dsp="docker system prune -af"
alias dl="docker logs -f"

dex() {
  docker exec -it "$1" "${@:2}"
}

dcl() {
  docker compose logs -f "$1"
}

