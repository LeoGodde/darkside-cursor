#!/usr/bin/env bash
# Darkside Cursor — remote installer (curl-based)
# Usage: curl -fsSL https://raw.githubusercontent.com/LeoGodde/darkside-cursor/main/install-remote.sh | bash
set -euo pipefail

REPO="LeoGodde/darkside-cursor"
TARGET_DIR=".cursor/rules"
DARKSIDE_HOME="$HOME/.darkside"
TMP_DIR="$(mktemp -d)"

cleanup() { rm -rf "$TMP_DIR"; }
trap cleanup EXIT

echo "Fetching latest Darkside Cursor release..."

# Get latest release tag
TAG="$(curl -sf "https://api.github.com/repos/$REPO/releases/latest" \
  | grep '"tag_name"' \
  | sed 's/.*"\(v\{0,1\}[^"]*\)".*/\1/')"

if [ -z "$TAG" ]; then
  echo "❌ Could not fetch latest release. Check your connection or visit:"
  echo "   https://github.com/$REPO/releases"
  exit 1
fi

VERSION="${TAG#v}"
echo "Installing Darkside Cursor $TAG..."

# Download and extract release tarball
curl -sfL "https://github.com/$REPO/archive/refs/tags/$TAG.tar.gz" \
  | tar -xz -C "$TMP_DIR"

EXTRACTED="$TMP_DIR/darkside-cursor-$VERSION"
[ -d "$EXTRACTED" ] || EXTRACTED="$(ls -d "$TMP_DIR"/darkside-cursor-* | head -1)"

mkdir -p "$TARGET_DIR"
mkdir -p "$DARKSIDE_HOME"

# Install rules
count=0
for file in "$EXTRACTED/.cursor/rules/"*.mdc; do
  [ -f "$file" ] || continue
  cp "$file" "$TARGET_DIR/$(basename "$file")"
  count=$((count + 1))
done

echo "✅ $count rules instaladas em $TARGET_DIR/"

# Save version
echo "$VERSION" > "$DARKSIDE_HOME/VERSION"
echo "✅ Versão $VERSION salva em $DARKSIDE_HOME/VERSION"

echo ""
echo "✅ Darkside Cursor $VERSION instalado."
echo ""
echo "Skills disponíveis:"
echo "  /darkside  /explore  /quest  /war-room  /interrogate"
echo "  /order66   /sith-agents  /inquisitor  /mission  /verdict  /guide"
echo ""
echo "Para atualizar no futuro:"
echo "  curl -fsSL https://raw.githubusercontent.com/$REPO/main/install-remote.sh | bash"
