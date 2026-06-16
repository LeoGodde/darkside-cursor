#!/bin/bash

set -e

TARGET_DIR=".cursor/rules"

SKILLS=(
  darkside
  explore
  quest
  war-room
  interrogate
  order66
  sith-agents
  inquisitor
  mission
  verdict
  guide
)

count=0
for skill in "${SKILLS[@]}"; do
  file="$TARGET_DIR/$skill.mdc"
  if [ -f "$file" ]; then
    rm "$file"
    count=$((count + 1))
  fi
done

if [ "$count" -eq 0 ]; then
  echo "⚠️  Nenhuma rule do Darkside encontrada em $TARGET_DIR/"
else
  echo "✅ Darkside removido — $count rules deletadas de $TARGET_DIR/"
fi
