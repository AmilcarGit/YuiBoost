#!/usr/bin/env bash
# CÓDIGO ORIGINAL DE YUIBOOST
set -uo pipefail

BIN_DIR="${PREFIX:-$HOME/.local}/bin"

echo "🌿 Desinstalando YuiBoost..."

if [[ -L "$BIN_DIR/yui" ]]; then
    rm -f "$BIN_DIR/yui"
    echo "✓ Enlace eliminado: $BIN_DIR/yui"
else
    echo "→ No se encontró un enlace global que eliminar."
fi

echo "→ El repositorio en sí no se elimina automáticamente."
echo "  Para borrarlo por completo: rm -rf \"$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)\""
echo "✓ Desinstalación completada."
