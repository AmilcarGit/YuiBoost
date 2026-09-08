#!/usr/bin/env bash
# CÓDIGO ORIGINAL DE YUIBOOST

has_root() {
    [[ "$(detect_root)" == "true" ]]
}

has_adb() {
    [[ "$(detect_adb)" == "true" ]]
}

has_termux_api() {
    [[ "$(detect_termux_api)" == "true" ]]
}

has_storage_access() {
    [[ "$(detect_storage_access)" == "true" ]]
}

# Prints the standard "not available" block and returns failure.
# Usage: require_root "gobernador de CPU" || return 1
require_root() {
    local feature="$1"
    if has_root; then
        return 0
    fi
    yui_warn "ROOT/ADB requerido para: ${feature}"
    yui_info "Esta acción no se aplicará. YuiBoost no simula optimizaciones."
    yui_log "SKIP" "feature=${feature} reason=no_root"
    return 1
}

print_permission_status() {
    if has_root; then
        printf 'ROOT: %s✓ disponible%s\n' "$C_GREEN" "$C_RESET"
    else
        printf 'ROOT: %s❌ no disponible%s\n' "$C_RED" "$C_RESET"
    fi
    if has_adb; then
        printf 'ADB (adbd): %s✓ en ejecución%s\n' "$C_GREEN" "$C_RESET"
    else
        printf 'ADB (adbd): %s❌ no detectado%s\n' "$C_RED" "$C_RESET"
    fi
    if has_termux_api; then
        printf 'Termux:API: %s✓ instalado%s\n' "$C_GREEN" "$C_RESET"
    else
        printf 'Termux:API: %s❌ no instalado%s\n' "$C_YELLOW" "$C_RESET"
    fi
    if has_storage_access; then
        printf 'Acceso a almacenamiento: %s✓ concedido%s\n' "$C_GREEN" "$C_RESET"
    else
        printf 'Acceso a almacenamiento: %s❌ no configurado (termux-setup-storage)%s\n' "$C_YELLOW" "$C_RESET"
    fi
}
