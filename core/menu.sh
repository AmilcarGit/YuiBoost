#!/usr/bin/env bash
# CÓDIGO ORIGINAL DE YUIBOOST

print_menu() {
    yui_title "🌿 YUI BOOST"
    echo
    printf ' 1. 🎮 Gaming\n'
    printf ' 2. ⚡ Optimizar\n'
    printf ' 3. 🧹 Limpiar\n'
    printf ' 4. 📊 Diagnóstico\n'
    printf ' 5. 🌡️  Temperatura\n'
    printf ' 6. 🔋 Batería\n'
    printf ' 7. 📈 Benchmark\n'
    printf ' 8. 🔄 Restaurar\n'
    printf ' 9. ⚙️  Configuración\n'
    printf ' 10. ❌ Salir\n'
    echo
}

print_config() {
    yui_title "⚙️  CONFIGURACIÓN"
    echo
    printf 'Directorio de YuiBoost: %s\n' "$YUI_HOME"
    printf 'Color activado: %s\n' "$([[ "$YUI_USE_COLOR" == "1" ]] && echo si || echo no)"
    printf 'Log: %s\n' "$YUI_LOG_FILE"
    printf 'Cambios registrados: %s\n' "$YUI_CHANGES_FILE"
    echo
}

menu_loop() {
    local choice
    while true; do
        print_menu
        read -r -p "Selecciona una opción [1-10]: " choice
        echo
        case "$choice" in
            1) run_gaming ;;
            2) run_optimize ;;
            3) run_cleanup ;;
            4) run_diagnostics ;;
            5) run_temperature ;;
            6) run_battery ;;
            7) run_benchmark ;;
            8) run_restore ;;
            9) print_config ;;
            10) yui_ok "Hasta pronto 🌿"; exit 0 ;;
            *) yui_err "Opción no válida." ;;
        esac
        read -r -p "Pulsa ENTER para continuar..." _
        echo
    done
}
