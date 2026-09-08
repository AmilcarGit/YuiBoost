#!/usr/bin/env bash
# CÓDIGO ORIGINAL DE YUIBOOST

run_battery() {
    yui_title "🔋 BATERÍA"
    echo
    if has_termux_api; then
        local json
        json="$(termux-battery-status 2>/dev/null)"
        if [[ -n "$json" ]]; then
            local pct status health temp plugged
            pct="$(printf '%s' "$json" | grep -o '"percentage":[0-9]*' | head -1 | cut -d: -f2)"
            status="$(printf '%s' "$json" | grep -o '"status":"[^"]*"' | head -1 | cut -d: -f2 | tr -d '"')"
            health="$(printf '%s' "$json" | grep -o '"health":"[^"]*"' | head -1 | cut -d: -f2 | tr -d '"')"
            temp="$(printf '%s' "$json" | grep -o '"temperature":[0-9.-]*' | head -1 | cut -d: -f2)"
            plugged="$(printf '%s' "$json" | grep -o '"plugged":"[^"]*"' | head -1 | cut -d: -f2 | tr -d '"')"
            printf 'Nivel: %s%%\n' "${pct:-?}"
            printf 'Estado: %s\n' "${status:-desconocido}"
            printf 'Salud: %s\n' "${health:-desconocida}"
            printf 'Temperatura: %s°C\n' "${temp:-?}"
            printf 'Conectado: %s\n' "${plugged:-desconocido}"
            echo
            yui_ok "Datos obtenidos vía Termux:API"
            return 0
        fi
    fi
    local cap_path
    cap_path="$(find /sys/class/power_supply -maxdepth 1 -iname '*battery*' -print -quit 2>/dev/null)"
    if [[ -n "$cap_path" && -r "$cap_path/capacity" ]]; then
        printf 'Nivel: %s%%\n' "$(cat "$cap_path/capacity" 2>/dev/null)"
        [[ -r "$cap_path/status" ]] && printf 'Estado: %s\n' "$(cat "$cap_path/status")"
        [[ -r "$cap_path/health" ]] && printf 'Salud: %s\n' "$(cat "$cap_path/health")"
        [[ -r "$cap_path/technology" ]] && printf 'Tecnología: %s\n' "$(cat "$cap_path/technology")"
        echo
        yui_info "Instala Termux:API (pkg install termux-api) para más detalle."
    else
        yui_warn "No se pudo leer el estado de la batería en este dispositivo."
        yui_info "Instala Termux:API: pkg install termux-api"
    fi
    echo
}
