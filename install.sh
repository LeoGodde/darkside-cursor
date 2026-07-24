#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/.cursor/rules"
TARGET_DIR=".cursor/rules"
DARKSIDE_HOME="$HOME/.darkside"

if [ ! -d "$SOURCE_DIR" ]; then
  echo "❌ Diretório de rules não encontrado: $SOURCE_DIR"
  exit 1
fi

mkdir -p "$TARGET_DIR"
mkdir -p "$DARKSIDE_HOME"

count=0
for file in "$SOURCE_DIR"/*.mdc; do
  [ -f "$file" ] || continue
  filename="$(basename "$file")"
  cp "$file" "$TARGET_DIR/$filename"
  count=$((count + 1))
done

if [ "$count" -eq 0 ]; then
  echo "❌ Nenhum arquivo .mdc encontrado em $SOURCE_DIR"
  exit 1
fi

echo "✅ Darkside instalado — $count rules copiadas para $TARGET_DIR/"

# Save installed version
if [ -f "$SCRIPT_DIR/VERSION" ]; then
  cp "$SCRIPT_DIR/VERSION" "$DARKSIDE_HOME/CURSOR-VERSION"
  VERSION="$(cat "$SCRIPT_DIR/VERSION")"
  echo "✅ Versão $VERSION salva em $DARKSIDE_HOME/CURSOR-VERSION"
fi

# Install update checker
if [ -f "$SCRIPT_DIR/scripts/check-update.sh" ]; then
  cp "$SCRIPT_DIR/scripts/check-update.sh" "$DARKSIDE_HOME/cursor-check-update.sh"
  chmod +x "$DARKSIDE_HOME/cursor-check-update.sh"
  echo "✅ Update checker instalado em $DARKSIDE_HOME/cursor-check-update.sh"
fi

echo ""
echo "Skills disponíveis:"
echo "  /darkside  /explore  /quest  /war-room  /interrogate"
echo "  /order66   /sith-agents  /inquisitor  /mission"
echo "  /verdict   /visual-fidelity  /hunter  /guide"
