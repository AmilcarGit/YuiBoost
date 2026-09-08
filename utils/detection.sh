# Battery: prefer termux-api if installed, fallback to sysfs power_supply (usually world-readable).
detect_battery() {
    if _has_cmd termux-battery-status; then
        local json
        json="$(termux-battery-status 2>/dev/null)"
        if [[ -n "$json" ]]; then
            local pct status
            pct="$(printf '%s' "$json" | grep -o '"percentage":[0-9]*' | head -1 | cut -d: -f2)"
            status="$(printf '%s' "$json" | grep -o '"status":"[^"]*"' | head -1 | cut -d: -f2 | tr -d '"')"
            printf 'Nivel: %s%% | Estado: %s (via Termux:API)' "${pct:-?}" "${status:-desconocido}"
            return 0
        fi
    fi
    local cap_path
    cap_path="$(find /sys/class/power_supply -maxdepth 1 -iname '*battery*' -print -quit 2>/dev/null)"
    if [[ -n "$cap_path" && -r "$cap_path/capacity" ]]; then
        local pct status
        pct="$(cat "$cap_path/capacity" 2>/dev/null)"
        status="$(cat "$cap_path/status" 2>/dev/null)"
        printf 'Nivel: %s%% | Estado: %s' "${pct:-?}" "${status:-desconocido}"
    else
        printf 'No disponible (instala Termux:API para más datos: pkg install termux-api)'
    fi
}

# Temperature: scans thermal zones exposed in sysfs; many devices restrict this.