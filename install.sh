#!/usr/bin/env bash
# CÓDIGO ORIGINAL DE YUIBOOST
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="${PREFIX:-$HOME/.local}/bin"

echo "🌿 Instalando YuiBoost..."

chmod +x "$SCRIPT_DIR/yui" \
         "$SCRIPT_DIR/install.sh" \
         "$SCRIPT_DIR/uninstall.sh" 2>/dev/null

mkdir -p "$SCRIPT_DIR/backups" "$SCRIPT_DIR/logs"

if [[ -d "$BIN_DIR" ]]; then
    ln -sf "$SCRIPT_DIR/yui" "$BIN_DIR/yui"
    echo "✓ Enlace creado: $BIN_DIR/yui"
    echo "  Ahora puedes ejecutar 'yui' desde cualquier directorio."
else
    echo "⚠️  No se encontró $BIN_DIR en el PATH."
    echo "   Puedes ejecutar YuiBoost directamente con: $SCRIPT_DIR/yui"
fi

echo "✓ Instalación completada."
echo "  Ejecuta: yui   (o ./yui si el enlace no se creó)"
