#!/usr/bin/env bash
# Link the Stow packages in this repo into $HOME.
# Refuses to replace an existing file that is not already this repo's symlink.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$DOTFILES"

packages=()
for name in bash git bat hypr shell foot starship; do
  [[ -d $name ]] && packages+=("$name")
done

if ((${#packages[@]} == 0)); then
  echo "no stow packages found in $DOTFILES" >&2
  exit 1
fi

stow --no-folding --target "$HOME" --verbose "${packages[@]}"

command -v hyprctl >/dev/null && hyprctl reload
command -v omarchy >/dev/null && omarchy restart terminal
