#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
IFS=$'\n\t'
CRAFT_LOG="./logs/actions.log"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

log_action() { echo "$(date +'%F %T') | $*" >> "$CRAFT_LOG"; }
error() { echo -e "${RED}[×] $*${NC}" >&2; log_action "ERROR: $*"; }
info() { echo -e "${GREEN}[✓] $*${NC}"; log_action "INFO: $*"; }
warn() { echo -e "${YELLOW}[!] $*${NC}"; log_action "WARN: $*"; }

check_permissions() {
  local perm="$1"
  case "$perm" in
    user) [[ "$(id -u)" -ge 1000 ]] ;;
    admin) [[ "$(id -u)" -eq 0 ]] ;;
    system) [[ "$(id -u)" -eq 0 ]] && [[ -f "/data/data/com.termux/files/usr/.system_mode" ]] ;;
    *) return 1 ;;
  esac
}

confirm() {
  read -r -p "${YELLOW}$1 [Y/n]: ${NC}" resp
  case "$resp" in [Yy]|"") return 0 ;; *) return 1 ;; esac
}

run_with_permissions() {
  local cmd="$1"
  local perm="$2"
  if check_permissions "$perm"; then
    eval "$cmd"
  else
    error "Permissão '$perm' necessária para esta operação."
    return 1
  fi
}

usage() {
  cat <<EOF
Craft - Gerenciador Avançado de Pacotes para Termux

Uso:
  craft.sh <comando> [argumentos]

Comandos:
  install <pacote>          Instalar pacote
  update-self              Atualizar Craft
  audit                    Auditoria de pacotes
  rollback <pacote>        Reverter instalação
  plugin <ação>            Gerenciar plugins
EOF
}

main() {
  [ $# -eq 0 ] && { usage; exit 1; }
  local cmd="$1"; shift
  case "$cmd" in
    install) run_with_permissions "ruby ./ruby/craft-core.rb install $1" user ;;
    update-self) run_with_permissions "ruby ./ruby/craft-core.rb update_self" admin ;;
    audit) run_with_permissions "ruby ./ruby/craft-core.rb audit" admin ;;
    rollback) run_with_permissions "ruby ./ruby/craft-core.rb rollback $1" admin ;;
    plugin) run_with_permissions "ruby ./ruby/craft-core.rb plugin $*" admin ;;
    *) usage; exit 1 ;;
  esac
}

main "$@"
