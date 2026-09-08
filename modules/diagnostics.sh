#!/usr/bin/env bash
# CÓDIGO ORIGINAL DE YUIBOOST

run_diagnostics() {
    yui_title "🌿 YUI DIAGNOSTIC"
    echo

    yui_section "📱 Dispositivo"
    printf 'Android: %s\n' "$(detect_android_version)"
    printf 'Fabricante: %s\n' "$(detect_manufacturer)"
    printf 'Modelo: %s\n' "$(detect_model)"
    printf 'Arquitectura: %s\n' "$(detect_arch)"
    printf 'Termux: %s\n' "$(detect_termux_version)"

    yui_section "🧠 RAM"
    read -r total avail <<< "$(detect_ram_raw)"
    printf 'Total: %s\n' "$(_kb_to_human "$total")"
    printf 'Disponible: %s\n' "$(_kb_to_human "$avail")"

    yui_section "⚙️  CPU"
    printf 'Hardware: %s\n' "$(detect_cpu_hardware)"
    printf 'Núcleos: %s\n' "$(detect_cpu_cores)"
    printf 'Frecuencia actual: %s\n' "$(detect_cpu_freq_current)"
    printf 'Rango disponible: %s\n' "$(detect_cpu_freq_range)"
    printf 'Gobernador: %s\n' "$(detect_cpu_governor)"

    yui_section "🌡️  Temperatura"
    detect_temperature

    yui_section "🔋 Batería"
    detect_battery
    echo

    yui_section "💾 Almacenamiento"
    detect_storage_human "$HOME"
    echo

    yui_section "🛡️  Permisos"
    print_permission_status
    echo
}

# Prints a compact machine-parseable snapshot used by benchmark before/after diffs.
diagnostics_snapshot() {
    read -r ram_total ram_avail <<< "$(detect_ram_raw)"
    printf 'cpu_freq=%s\nram_avail_kb=%s\nstorage=%s\n' \
        "$(detect_cpu_freq_current)" \
        "$ram_avail" \
        "$(detect_storage_human "$HOME")"
}