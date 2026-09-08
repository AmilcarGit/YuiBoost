#!/usr/bin/env bash
# CÓDIGO ORIGINAL DE YUIBOOST

run_restore() {
    yui_title "🔄 RESTAURAR CAMBIOS"
    echo

    logging_init
    if ! has_recorded_changes; then
        yui_ok "No hay cambios para restaurar."
        echo
        return 0
    fi

    printf 'Cambios registrados:\n'
    local line count=0
    while IFS='|' read -r date_field target old new; do
        [[ -z "$date_field" ]] && continue
        count=$((count + 1))
        printf '  [%s] %s\n' "$date_field" "$target"
        printf '      %s → %s\n' "$old" "$new"
    done < "$YUI_CHANGES_FILE"
    echo

    read -r -p "¿Restaurar los $count cambio(s) anteriores? (si/no): " confirm
    if [[ "$confirm" != "si" ]]; then
        yui_info "Restauración cancelada."
        echo
        return 0
    fi

    local restored=0 failed=0
    local remaining_file
    remaining_file="$(mktemp 2>/dev/null || printf '%s.tmp' "$YUI_CHANGES_FILE")"
    : > "$remaining_file"

    while IFS='|' read -r date_field target old new; do
        [[ -z "$date_field" ]] && continue
        if [[ -w "$target" ]]; then
            if echo "$old" > "$target" 2>/dev/null; then
                yui_ok "Restaurado: $target → $old"
                yui_log "RESTORE" "target=$target restored_to=$old"
                restored=$((restored + 1))
                continue
            fi
        fi
        yui_warn "No se pudo restaurar: $target (ya no accesible)"
        failed=$((failed + 1))
        printf '%s|%s|%s|%s\n' "$date_field" "$target" "$old" "$new" >> "$remaining_file"
    done < "$YUI_CHANGES_FILE"

    mv "$remaining_file" "$YUI_CHANGES_FILE"

    echo
    yui_ok "Restauración completada: $restored aplicado(s), $failed pendiente(s)."
    echo
}
