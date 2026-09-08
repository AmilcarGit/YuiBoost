#!/usr/bin/env bash
# CÓDIGO ORIGINAL DE YUIBOOST

# Whitelist of paths YuiBoost is allowed to inspect/clean. Every path here is
# owned by Termux itself — never a user data directory, never /sdcard.
_cleanup_targets() {
    local prefix="${PREFIX:-/usr}"
    local targets=(
        "$prefix/var/cache/apt/archives"
        "$prefix/tmp"
        "$HOME/.cache"
    )
    local t
    for t in "${targets[@]}"; do
        [[ -d "$t" ]] && printf '%s\n' "$t"
    done
}

_dir_size_human() {
    if _has_cmd du; then
        du -sh "$1" 2>/dev/null | awk '{print $1}'
    else
        printf '?'
    fi
}

run_cleanup() {
    yui_title "🧹 LIMPIEZA SEGURA"
    echo
    yui_info "YuiBoost solo revisa caché temporal propia de Termux."
    yui_info "Nunca toca fotos, vídeos, documentos, WhatsApp ni otras apps."
    echo

    local paths=()
    while IFS= read -r p; do
        [[ -n "$p" ]] && paths+=("$p")
    done < <(_cleanup_targets)

    if [[ "${#paths[@]}" -eq 0 ]]; then
        yui_warn "No se encontraron rutas de caché accesibles."
        return 0
    fi

    local total_before=0
    printf 'Rutas detectadas:\n'
    local p size
    for p in "${paths[@]}"; do
        size="$(_dir_size_human "$p")"
        printf '  %s%s%s — %s\n' "$C_CYAN" "$p" "$C_RESET" "$size"
    done
    echo

    read -r -p "¿Eliminar el contenido de estas rutas? (escribe 'si' para confirmar): " confirm
    if [[ "$confirm" != "si" ]]; then
        yui_info "Limpieza cancelada. No se eliminó nada."
        return 0
    fi

    # Deletion always stays scoped to the exact path being reported above —
    # never delegated to a global command like "apt-get clean", which could
    # act outside the directories we just showed the user.
    for p in "${paths[@]}"; do
        size="$(_dir_size_human "$p")"
        find "$p" -mindepth 1 -maxdepth 4 -type f -exec rm -f {} + 2>/dev/null
        find "$p" -mindepth 1 -type d -empty -exec rmdir {} + 2>/dev/null
        yui_ok "Limpiado: $p (aprox. $size antes)"
        yui_log "CLEANUP" "path=$p size_before=$size"
    done

    echo
    yui_ok "Limpieza completada."
}
