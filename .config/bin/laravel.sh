#!/usr/bin/env bash
# laravel.sh - Script helper avançado para comandos Laravel no Docker
# Uso: ./laravel.sh [comando] [argumentos]

set -e

# Cores para output (compatível com kitty/zsh)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
BOLD=$(tput bold)
NC=$(tput sgr0) # No Color / Reset

# Configurações
COMPOSE_FILE="docker-compose.yml"
PROJECT_NAME=$(basename "$(pwd)" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g')

# Função para detectar o container da aplicação automaticamente
get_app_container() {
    local container=$(docker-compose ps -q app 2>/dev/null)

    if [ -z "$container" ]; then
        # Fallback: tenta encontrar por nome
        container=$(docker ps --filter "name=${PROJECT_NAME}-app" --format "{{.Names}}" | head -n 1)
    fi

    if [ -z "$container" ]; then
        echo -e "${RED}❌ Container da aplicação não encontrado!${NC}" >&2
        echo -e "${YELLOW}Execute 'docker-compose up -d' primeiro${NC}" >&2
        exit 1
    fi

    echo "$container"
}

# Função para verificar se os containers estão rodando
check_containers() {
    if ! docker-compose ps | grep -q "Up"; then
        echo -e "${RED}❌ Nenhum container está rodando!${NC}" >&2
        echo -e "${YELLOW}Execute 'docker-compose up -d' primeiro${NC}" >&2
        exit 1
    fi
}

# Função para executar comandos artisan
artisan() {
    local container=$(get_app_container)
    docker exec -it "$container" su-exec laravel php artisan "$@"
}

# Função para entrar no shell como laravel
shell() {
    local container=$(get_app_container)
    echo -e "${GREEN}🐚 Entrando no shell do container como usuário laravel...${NC}"
    docker exec -it "$container" su-exec laravel sh
}

# Função para shell como root
root_shell() {
    local container=$(get_app_container)
    echo -e "${GREEN}🔑 Entrando no shell do container como root...${NC}"
    docker exec -it "$container" sh
}

# Função para composer
composer() {
    local container=$(get_app_container)
    docker exec -it "$container" su-exec laravel composer "$@"
}

# Função para npm
npm() {
    local container=$(get_app_container)
    docker exec -it "$container" su-exec laravel npm "$@"
}

# Função para tinker
tinker() {
    local container=$(get_app_container)
    echo -e "${GREEN}🔧 Abrindo Tinker...${NC}"
    docker exec -it "$container" su-exec laravel php artisan tinker
}

# Função para ver logs da aplicação
logs() {
    local service="${1:-app}"
    local follow="${2:--f}"

    echo -e "${GREEN}📋 Mostrando logs do serviço: ${service}${NC}"
    docker-compose logs "$follow" --tail=100 "$service"
}

# Função para ver logs do Laravel
laravel_logs() {
    local container=$(get_app_container)
    echo -e "${GREEN}📋 Mostrando logs do Laravel...${NC}"
    docker exec -it "$container" tail -f storage/logs/laravel.log
}

# Função para listar serviços
services() {
    echo -e "${GREEN}📦 Serviços disponíveis:${NC}"
    docker-compose ps
}

# Função para status detalhado
status() {
    echo -e "${BLUE}════════════════════════════════════════${NC}"
    echo -e "${GREEN}📊 Status do Projeto${NC}"
    echo -e "${BLUE}════════════════════════════════════════${NC}"

    docker-compose ps

    echo ""
    echo -e "${BLUE}════════════════════════════════════════${NC}"
    echo -e "${GREEN}💾 Volumes${NC}"
    echo -e "${BLUE}════════════════════════════════════════${NC}"
    docker volume ls | grep "$PROJECT_NAME"

    echo ""
    echo -e "${BLUE}════════════════════════════════════════${NC}"
    echo -e "${GREEN}🌐 Networks${NC}"
    echo -e "${BLUE}════════════════════════════════════════${NC}"
    docker network ls | grep "$PROJECT_NAME"
}

# Função para reiniciar serviços
restart() {
    local service="${1:-}"

    if [ -z "$service" ]; then
        echo -e "${YELLOW}🔄 Reiniciando todos os serviços...${NC}"
        docker-compose restart
    else
        echo -e "${YELLOW}🔄 Reiniciando serviço: ${service}${NC}"
        docker-compose restart "$service"
    fi

    echo -e "${GREEN}✅ Serviço(s) reiniciado(s)!${NC}"
}

# Função para limpar cache
clear_cache() {
    local container=$(get_app_container)
    echo -e "${YELLOW}🧹 Limpando cache do Laravel...${NC}"

    docker exec -it "$container" su-exec laravel php artisan config:clear
    docker exec -it "$container" su-exec laravel php artisan cache:clear
    docker exec -it "$container" su-exec laravel php artisan view:clear
    docker exec -it "$container" su-exec laravel php artisan route:clear

    echo -e "${GREEN}✅ Cache limpo!${NC}"
}

# Função para otimizar
optimize() {
    local container=$(get_app_container)
    echo -e "${YELLOW}⚡ Otimizando Laravel...${NC}"

    docker exec -it "$container" su-exec laravel php artisan config:cache
    docker exec -it "$container" su-exec laravel php artisan route:cache
    docker exec -it "$container" su-exec laravel php artisan view:cache

    echo -e "${GREEN}✅ Otimização concluída!${NC}"
}

# Função para migrations
migrate() {
    local container=$(get_app_container)
    local option="${1:---force}"

    echo -e "${YELLOW}🗄️  Executando migrations...${NC}"
    docker exec -it "$container" su-exec laravel php artisan migrate "$option"
    echo -e "${GREEN}✅ Migrations executadas!${NC}"
}

# Função para fresh migrations
fresh() {
    local container=$(get_app_container)

    echo -e "${RED}⚠️  ATENÇÃO: Isso irá apagar todos os dados!${NC}"
    read -p "Tem certeza? (yes/N): " confirm

    if [ "$confirm" = "yes" ]; then
        echo -e "${YELLOW}🗄️  Executando migrate:fresh...${NC}"
        docker exec -it "$container" su-exec laravel php artisan migrate:fresh --force
        echo -e "${GREEN}✅ Database recriado!${NC}"
    else
        echo -e "${YELLOW}❌ Operação cancelada${NC}"
    fi
}

# Função para seeders
seed() {
    local container=$(get_app_container)
    local class="${1:-}"

    echo -e "${YELLOW}🌱 Executando seeders...${NC}"

    if [ -z "$class" ]; then
        docker exec -it "$container" su-exec laravel php artisan db:seed --force
    else
        docker exec -it "$container" su-exec laravel php artisan db:seed --class="$class" --force
    fi

    echo -e "${GREEN}✅ Seeders executados!${NC}"
}

# Função para testes
test() {
    local container=$(get_app_container)
    echo -e "${YELLOW}🧪 Executando testes...${NC}"
    docker exec -it "$container" su-exec laravel php artisan test "$@"
}

# Função para acessar serviços específicos
service_shell() {
    local service="$1"

    if [ -z "$service" ]; then
        echo -e "${RED}❌ Especifique um serviço!${NC}" >&2
        echo -e "${YELLOW}Serviços disponíveis:${NC}"
        docker-compose ps --services
        exit 1
    fi

    echo -e "${GREEN}🐚 Entrando no shell do serviço: ${service}${NC}"
    docker-compose exec "$service" sh
}

# Função para executar comandos em qualquer serviço
exec_service() {
    local service="$1"
    shift

    if [ -z "$service" ]; then
        echo -e "${RED}❌ Especifique um serviço!${NC}" >&2
        exit 1
    fi

    docker-compose exec "$service" "$@"
}

# Função para backup do banco
backup_db() {
    local container=$(get_app_container)
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local filename="backup_${timestamp}.sql"

    echo -e "${YELLOW}💾 Criando backup do banco de dados...${NC}"

    # Detecta o tipo de banco
    local db_connection=$(docker exec "$container" su-exec laravel php -r "echo env('DB_CONNECTION');")

    case "$db_connection" in
        "pgsql")
            docker-compose exec -T db pg_dump -U "${DB_USERNAME:-laravel}" "${DB_DATABASE:-laravel}" > "$filename"
            ;;
        "mysql")
            docker-compose exec -T db mysqldump -u "${DB_USERNAME:-laravel}" -p"${DB_PASSWORD:-password}" "${DB_DATABASE:-laravel}" > "$filename"
            ;;
        *)
            echo -e "${RED}❌ Tipo de banco não suportado: ${db_connection}${NC}"
            exit 1
            ;;
    esac

    echo -e "${GREEN}✅ Backup criado: ${filename}${NC}"
}

# Função para mostrar informações do sistema
info() {
    local container=$(get_app_container)

    echo -e "${BLUE}════════════════════════════════════════${NC}"
    echo -e "${GREEN}ℹ️  Informações do Sistema${NC}"
    echo -e "${BLUE}════════════════════════════════════════${NC}"

    echo -e "${YELLOW}Laravel Version:${NC}"
    docker exec "$container" su-exec laravel php artisan --version

    echo ""
    echo -e "${YELLOW}PHP Version:${NC}"
    docker exec "$container" php -v | head -n 1

    echo ""
    echo -e "${YELLOW}Composer Version:${NC}"
    docker exec "$container" composer --version

    echo ""
    echo -e "${YELLOW}Database:${NC}"
    docker exec "$container" su-exec laravel php -r "echo 'Connection: ' . env('DB_CONNECTION') . PHP_EOL; echo 'Database: ' . env('DB_DATABASE') . PHP_EOL;"
}

# Função de ajuda
show_help() {
    cat << EOF
${GREEN}🚀 Laravel Docker Helper${NC}

${YELLOW}Uso:${NC} $0 [comando] [argumentos]

${YELLOW}Comandos Artisan:${NC}
  artisan [cmd]         Executa comando artisan
  tinker               Abre o Tinker
  migrate              Executa migrations
  fresh                Executa migrate:fresh (apaga tudo!)
  seed [class]         Executa seeders
  test [args]          Executa testes

${YELLOW}Composer & NPM:${NC}
  composer [cmd]        Executa comando composer
  npm [cmd]            Executa comando npm

${YELLOW}Shell & Acesso:${NC}
  shell                Entra no shell como laravel
  root                 Entra no shell como root
  service [nome]       Entra no shell de um serviço
  exec [srv] [cmd]     Executa comando em um serviço

${YELLOW}Cache & Otimização:${NC}
  clear                Limpa todo cache
  optimize             Otimiza a aplicação (cache configs)

${YELLOW}Logs & Debug:${NC}
  logs [serviço]       Mostra logs (padrão: app)
  laravel-logs         Mostra logs do Laravel

${YELLOW}Gerenciamento:${NC}
  services             Lista todos os serviços
  status               Status detalhado do projeto
  restart [serviço]    Reinicia serviço(s)
  info                 Informações do sistema
  backup-db            Faz backup do banco de dados

${YELLOW}Exemplos:${NC}
  $0 artisan migrate
  $0 artisan make:model Post -m
  $0 clear
  $0 logs nginx
  $0 service minio
  $0 restart app

EOF
}

# Verificar se há argumentos
if [ $# -eq 0 ]; then
    show_help
    exit 0
fi

# Processar comando
case "$1" in
    "artisan")
        shift
        check_containers
        artisan "$@"
        ;;
    "shell")
        check_containers
        shell
        ;;
    "root")
        check_containers
        root_shell
        ;;
    "composer")
        shift
        check_containers
        composer "$@"
        ;;
    "npm")
        shift
        check_containers
        npm "$@"
        ;;
    "tinker")
        check_containers
        tinker
        ;;
    "logs")
        shift
        check_containers
        logs "$@"
        ;;
    "laravel-logs")
        check_containers
        laravel_logs
        ;;
    "services"|"ps")
        check_containers
        services
        ;;
    "status"|"st")
        check_containers
        status
        ;;
    "restart")
        shift
        check_containers
        restart "$@"
        ;;
    "clear"|"clear-cache")
        check_containers
        clear_cache
        ;;
    "optimize")
        check_containers
        optimize
        ;;
    "migrate")
        shift
        check_containers
        migrate "$@"
        ;;
    "fresh"|"migrate:fresh")
        check_containers
        fresh
        ;;
    "seed")
        shift
        check_containers
        seed "$@"
        ;;
    "test"|"tests")
        shift
        check_containers
        test "$@"
        ;;
    "service")
        shift
        check_containers
        service_shell "$@"
        ;;
    "exec")
        shift
        check_containers
        exec_service "$@"
        ;;
    "backup-db"|"backup")
        check_containers
        backup_db
        ;;
    "info")
        check_containers
        info
        ;;
    "help"|"--help"|"-h")
        show_help
        ;;
    *)
        echo -e "${RED}❌ Comando desconhecido: $1${NC}"
        echo ""
        show_help
        exit 1
        ;;
esac
