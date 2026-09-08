#!/usr/bin/env bash
# CÓDIGO ORIGINAL DE YUIBOOST

# Sets scaling_governor to "performance" on every core where the kernel
# exposes that governor as available. Records the previous value per core
# so restore.sh (option 8) can put it back exactly as it was.
_optimize_set_performance_governor() {
    local applied=0
    local cpu_dir
    for cpu_dir in /sys/devices/system/cpu/cpu[0-9]*/cpufreq; do
        [[ -d "$cpu_dir" ]] || continue
        local avail="$cpu_dir/scaling_available_governors"
        local gov_file="$cpu_dir/scaling_governor"
        [[ -r "$avail" && -w "$gov_file" ]] || continue
        if grep -qw "performance" "$avail" 2>/dev/null; then
            local old
            old="$(cat "$gov_file" 2>/dev/null)"
            if [[ "$old" != "performance" ]]; then
                if echo "performance" > "$gov_file" 2>/dev/null; then
                    record_change "$gov_file" "$old" "performance"
                    applied=$((applied + 1))
                fi
            fi
        fi
    done
    printf '%d' "$applied"
}

run_optimize() {
    yui_title "⚡ OPTIMIZACIÓN GENERAL"
    echo

    yui_section "Acciones sin permisos especiales"
    yui_info "Sincronizando escritura de disco (sync)..."
    sync 2>/dev/null && yui_ok "sync completado" || yui_warn "sync no disponible"

    if _has_cmd apt-get; then
        yui_info "Limpiando paquetes de Termux ya descargados (apt-get clean)..."
        apt-get clean 2>/dev/null && yui_ok "Caché de paquetes limpiada" || yui_warn "No se pudo limpiar"
    fi

    echo
    yui_section "Acciones que requieren ROOT"
    if has_root; then
        read -r -p "¿Aplicar gobernador de CPU 'performance' donde esté disponible? (si/no): " ans
        if [[ "$ans" == "si" ]]; then
            local n
            n="$(_optimize_set_performance_governor)"
            if [[ "$n" -gt 0 ]]; then
                yui_ok "Gobernador 'performance' aplicado en $n núcleo(s)."
                yui_info "Usa './yui restore' para revertirlo."
            else
                yui_info "Ningún núcleo permitió el cambio (ya estaba aplicado o no expuesto)."
            fi
        else
            yui_info "Omitido por el usuario."
        fi
    else
        require_root "gobernador de CPU y liberación de caché del sistema"
    fi

    echo
    yui_ok "Optimización general finalizada."
    echo
    yui_info "Recuerda: YuiBoost no puede aumentar la RAM física, hacer overclock"
    yui_info "ni garantizar más FPS. Consulta el README para más detalle."
    echo
}
