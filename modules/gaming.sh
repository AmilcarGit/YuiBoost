#!/usr/bin/env bash
# CÓDIGO ORIGINAL DE YUIBOOST

run_gaming() {
    yui_title "🎮 MODO GAMING"
    echo

    yui_section "1/7 · Diagnóstico inicial"
    local before
    before="$(diagnostics_snapshot)"
    printf '%s\n' "$before" | sed 's/^/  /'

    yui_section "2/7 · Registro de lo que se intentará modificar"
    local planned=()
    if has_root; then
        planned+=("Gobernador de CPU → performance (por núcleo, si está disponible)")
    fi
    planned+=("Sincronización de disco (sync)")
    if [[ "${#planned[@]}" -eq 0 ]]; then
        yui_info "Ninguna acción disponible sin ROOT/ADB."
    else
        local item
        for item in "${planned[@]}"; do
            printf '  - %s\n' "$item"
        done
    fi
    yui_log "GAMING" "planned=${planned[*]}"

    yui_section "3/7 · Comprobación de permisos"
    print_permission_status

    yui_section "4/7 · Aplicando únicamente lo permitido"
    sync 2>/dev/null && yui_ok "Disco sincronizado" || yui_warn "sync no disponible"
    local governor_applied=0
    if has_root; then
        governor_applied="$(_optimize_set_performance_governor)"
        if [[ "$governor_applied" -gt 0 ]]; then
            yui_ok "Gobernador 'performance' aplicado en $governor_applied núcleo(s)."
        else
            yui_info "Gobernador sin cambios (ya óptimo o no expuesto por el kernel)."
        fi
    else
        require_root "gobernador de CPU en modo Gaming"
    fi
    yui_info "YuiBoost no cierra aplicaciones de forma agresiva ni mata procesos"
    yui_info "críticos: eso requiere permisos que Termux no tiene sin ROOT/ADB."

    yui_section "5/7 · Resumen de lo aplicado"
    printf '  sync: aplicado\n'
    printf '  gobernador performance: %s núcleo(s)\n' "$governor_applied"

    yui_section "6/7 · Diagnóstico posterior"
    local after
    after="$(diagnostics_snapshot)"
    printf '%s\n' "$after" | sed 's/^/  /'

    yui_section "7/7 · Comparación"
    local b_freq a_freq
    b_freq="$(printf '%s' "$before" | awk -F= '/^cpu_freq/{print $2}')"
    a_freq="$(printf '%s' "$after" | awk -F= '/^cpu_freq/{print $2}')"
    if [[ "$b_freq" != "$a_freq" ]]; then
        printf '  Frecuencia CPU: %s → %s\n' "$b_freq" "$a_freq"
    else
        printf '  Frecuencia CPU: sin cambio medible (%s)\n' "$a_freq"
    fi
    echo
    yui_ok "Modo Gaming finalizado."
    echo
}
