#!/usr/bin/env bash
# CÓDIGO ORIGINAL DE YUIBOOST

_has_cmd() {
    command -v "$1" >/dev/null 2>&1
}

_getprop() {
    if _has_cmd getprop; then
        getprop "$1" 2>/dev/null
    fi
}

detect_termux_version() {
    if [[ -n "${TERMUX_VERSION:-}" ]]; then
        printf '%s' "$TERMUX_VERSION"
    elif _has_cmd dpkg && dpkg -s termux-tools >/dev/null 2>&1; then
        dpkg -s termux-tools 2>/dev/null | awk -F': ' '/^Version/{print $2}'
    else
        printf 'No detectado'
    fi
}

detect_android_version() {
    local v
    v="$(_getprop ro.build.version.release)"
    [[ -n "$v" ]] && printf '%s' "$v" || printf 'No disponible'
}

detect_manufacturer() {
    local v
    v="$(_getprop ro.product.manufacturer)"
    [[ -n "$v" ]] && printf '%s' "$v" || printf 'Desconocido'
}

detect_model() {
    local v
    v="$(_getprop ro.product.model)"
    [[ -n "$v" ]] && printf '%s' "$v" || printf 'Desconocido'
}

detect_arch() {
    uname -m 2>/dev/null || printf 'Desconocida'
}

detect_cpu_hardware() {
    if [[ -r /proc/cpuinfo ]]; then
        local hw
        hw="$(awk -F': ' '/^Hardware/{print $2; exit}' /proc/cpuinfo)"
        if [[ -z "$hw" ]]; then
            hw="$(_getprop ro.board.platform)"
        fi
        [[ -n "$hw" ]] && printf '%s' "$hw" || printf 'No disponible'
    else
        printf 'No disponible'
    fi
}

detect_cpu_cores() {
    if _has_cmd nproc; then
        nproc 2>/dev/null
    elif [[ -r /proc/cpuinfo ]]; then
        grep -c '^processor' /proc/cpuinfo
    else
        printf '0'
    fi
}

# Prints "min-max MHz" using cpufreq sysfs if readable, otherwise a clear notice.
detect_cpu_freq_range() {
    local cpu0="/sys/devices/system/cpu/cpu0/cpufreq"
    if [[ -r "$cpu0/scaling_min_freq" && -r "$cpu0/scaling_max_freq" ]]; then
        local min max
        min="$(($(cat "$cpu0/scaling_min_freq") / 1000))"
        max="$(($(cat "$cpu0/scaling_max_freq") / 1000))"
        printf '%s-%s MHz' "$min" "$max"
    else
        printf 'No expuesto sin permisos adicionales'
    fi
}

detect_cpu_freq_current() {
    local cpu0="/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq"
    if [[ -r "$cpu0" ]]; then
        printf '%s MHz' "$(( $(cat "$cpu0") / 1000 ))"
    else
        printf 'No disponible'
    fi
}

detect_cpu_governor() {
    local gov="/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor"
    if [[ -r "$gov" ]]; then
        cat "$gov"
    else
        printf 'No disponible'
    fi
}

# Returns "total_kb avail_kb" via /proc/meminfo
detect_ram_raw() {
    if [[ -r /proc/meminfo ]]; then
        local total avail
        total="$(awk '/^MemTotal:/{print $2}' /proc/meminfo)"
        avail="$(awk '/^MemAvailable:/{print $2}' /proc/meminfo)"
        printf '%s %s' "${total:-0}" "${avail:-0}"
    else
        printf '0 0'
    fi
}

_kb_to_human() {
    local kb="$1"
    if [[ "$kb" -ge 1048576 ]]; then
        awk -v k="$kb" 'BEGIN{printf "%.1f GB", k/1048576}'
    else
        awk -v k="$kb" 'BEGIN{printf "%.0f MB", k/1024}'
    fi
}

detect_ram_human() {
    read -r total avail <<< "$(detect_ram_raw)"
    printf 'Total: %s | Disponible: %s' "$(_kb_to_human "$total")" "$(_kb_to_human "$avail")"
}

detect_storage_human() {
    local target="${1:-$HOME}"
    if _has_cmd df; then
        df -h "$target" 2>/dev/null | awk 'NR==2{printf "Usado: %s / Total: %s (%s)", $3, $2, $5}'
    else
        printf 'No disponible'
    fi
}

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
    local cap_path status_path
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
detect_temperature() {
    local found=0
    local out=""
    if [[ -d /sys/class/thermal ]]; then
        local zone
        for zone in /sys/class/thermal/thermal_zone*; do
            [[ -d "$zone" ]] || continue
            [[ -r "$zone/temp" ]] || continue
            local type raw milli
            type="$(cat "$zone/type" 2>/dev/null)"
            raw="$(cat "$zone/temp" 2>/dev/null)"
            [[ "$raw" =~ ^[0-9]+$ ]] || continue
            found=1
            if [[ "$raw" -gt 1000 ]]; then
                milli="$(awk -v r="$raw" 'BEGIN{printf "%.1f", r/1000}')"
            else
                milli="$raw"
            fi
            out+="  ${type:-zona}: ${milli}°C"$'\n'
        done
    fi
    if [[ "$found" -eq 1 ]]; then
        printf '%s' "$out"
    elif _has_cmd termux-battery-status; then
        local json bt
        json="$(termux-battery-status 2>/dev/null)"
        bt="$(printf '%s' "$json" | grep -o '"temperature":[0-9.-]*' | head -1 | cut -d: -f2)"
        if [[ -n "$bt" ]]; then
            printf '  Temperatura de batería: %s°C (via Termux:API)\n' "$bt"
        else
            printf 'No disponible en este dispositivo\n'
        fi
    else
        printf 'No disponible en este dispositivo\n'
    fi
}

# Root detection: checks for su binary presence only. Does not attempt to elevate
# or run any command as root — a real yes/no answer without side effects.
detect_root() {
    local candidates=(
        "/system/bin/su" "/system/xbin/su" "/sbin/su"
        "/system/bin/.ext/.su" "/data/local/xbin/su" "/data/local/bin/su"
    )
    if _has_cmd su; then
        printf 'true'
        return 0
    fi
    local p
    for p in "${candidates[@]}"; do
        if [[ -x "$p" ]]; then
            printf 'true'
            return 0
        fi
    done
    printf 'false'
}

# ADB detection: reads the adbd service state property (readable without root
# on stock Android). Reports whether the ADB daemon is currently running —
# it cannot detect wireless-only debugging states beyond that property.
detect_adb() {
    local svc
    svc="$(_getprop init.svc.adbd)"
    if [[ "$svc" == "running" ]]; then
        printf 'true'
    else
        printf 'false'
    fi
}

detect_termux_api() {
    if _has_cmd termux-battery-status; then
        printf 'true'
    else
        printf 'false'
    fi
}

detect_storage_access() {
    if [[ -d "$HOME/storage/shared" ]]; then
        printf 'true'
    else
        printf 'false'
    fi
}
