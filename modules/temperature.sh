#!/usr/bin/env bash
# CÓDIGO ORIGINAL DE YUIBOOST

run_temperature() {
    yui_title "🌡️  TEMPERATURA"
    echo
    local output
    output="$(detect_temperature)"
    printf '%s\n' "$output"
    if [[ -z "$output" || "$output" == "No disponible en este dispositivo" ]]; then
        yui_warn "Este dispositivo no expone sensores de temperatura sin ROOT."
        yui_info "Instala Termux:API (pkg install termux-api) para la temperatura de la batería."
    else
        yui_ok "Lectura obtenida desde /sys/class/thermal"
    fi
    echo
}
