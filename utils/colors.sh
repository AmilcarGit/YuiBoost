#!/usr/bin/env bash
# CÓDIGO ORIGINAL DE YUIBOOST

YUI_NO_COLOR="${YUI_NO_COLOR:-0}"

colors_init() {
    if [[ "$YUI_NO_COLOR" == "1" ]] || [[ -n "${NO_COLOR:-}" ]] || [[ ! -t 1 ]]; then
        YUI_USE_COLOR=0
    else
        case "${TERM:-}" in
            ""|dumb) YUI_USE_COLOR=0 ;;
            *) YUI_USE_COLOR=1 ;;
        esac
    fi

    if [[ "$YUI_USE_COLOR" == "1" ]]; then
        C_RESET=$'\033[0m'
        C_BOLD=$'\033[1m'
        C_DIM=$'\033[2m'
        C_GREEN=$'\033[38;5;114m'
        C_CYAN=$'\033[38;5;80m'
        C_YELLOW=$'\033[38;5;222m'
        C_RED=$'\033[38;5;203m'
        C_MAGENTA=$'\033[38;5;176m'
        C_BLUE=$'\033[38;5;111m'
        C_GRAY=$'\033[38;5;245m'
    else
        C_RESET=""
        C_BOLD=""
        C_DIM=""
        C_GREEN=""
        C_CYAN=""
        C_YELLOW=""
        C_RED=""
        C_MAGENTA=""
        C_BLUE=""
        C_GRAY=""
    fi
}

yui_ok() {
    printf '%s✓%s %s\n' "$C_GREEN" "$C_RESET" "$1"
}

yui_warn() {
    printf '%s⚠️  %s%s\n' "$C_YELLOW" "$1" "$C_RESET"
}

yui_err() {
    printf '%s✗ %s%s\n' "$C_RED" "$1" "$C_RESET"
}

yui_info() {
    printf '%s→%s %s\n' "$C_CYAN" "$C_RESET" "$1"
}

yui_title() {
    local text="$1"
    local width=34
    printf '%s╭' "$C_MAGENTA"
    printf '─%.0s' $(seq 1 "$width")
    printf '╮\n'
    printf '│  %s%-*s%s│\n' "$C_RESET$C_BOLD" $((width - 3)) "$text" "$C_RESET$C_MAGENTA"
    printf '╰'
    printf '─%.0s' $(seq 1 "$width")
    printf '╯%s\n' "$C_RESET"
}

yui_section() {
    printf '\n%s%s%s%s\n' "$C_BOLD" "$C_CYAN" "$1" "$C_RESET"
}

colors_init
