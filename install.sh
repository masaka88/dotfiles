#!/bin/bash
set -eu
DOTFILES="$(cd "$(dirname "$0")" && pwd)"

# Install Claude settings and skills
mkdir -p ~/.claude/skills
ln -sf "$DOTFILES/.claude/settings.json" ~/.claude/settings.json

for skill in "$DOTFILES"/.claude/skills/*/; do
  [ -d "$skill" ] || continue
  ln -sfn "${skill%/}" ~/.claude/skills/"$(basename "$skill")"
done

echo "Done!"
