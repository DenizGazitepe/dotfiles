#!/usr/bin/env bash
# Make Omarchy's terminal configs include the dotfiles-owned files that the
# ghostty, kitty, foot and alacritty stow packages link next to them.
# Omarchy owns the main configs: font changes and migrations rewrite them in
# place, and a refresh can replace one and drop the include. This adds the
# include when it's missing and is safe to rerun. Terminals without a config
# are skipped.
set -euo pipefail

config="${XDG_CONFIG_HOME:-$HOME/.config}"
comment="# Settings owned by ~/dotfiles; keep this last so they win"

# append_include <file> <include line> [section header]
append_include() {
  local file=$1 line=$2 section=${3:-}

  [[ -f $file ]] || return 0
  grep -qxF "$line" "$file" && return 0

  printf '\n%s\n%s%s\n' "$comment" "${section:+$section$'\n'}" "$line" >>"$file"
  echo "terminal-includes: $file now includes dotfiles settings"
}

append_include "$config/ghostty/config" 'config-file = ?"~/.config/ghostty/dotfiles.conf"'
append_include "$config/kitty/kitty.conf" 'include ~/.config/kitty/dotfiles.conf'
append_include "$config/foot/foot.ini" 'include=~/.config/foot/dotfiles.ini' '[main]'

# Alacritty takes imports from a list, and they apply before the file itself.
alacritty="$config/alacritty/alacritty.toml"
entry='"~/.config/alacritty/dotfiles.toml"'
if [[ -f $alacritty ]] && ! grep -qF "$entry" "$alacritty"; then
  sed -i -E "s|^(general\.import = \[.*[^[:space:]])[[:space:]]*\]$|\1, $entry ]|" "$alacritty"
  if grep -qF "$entry" "$alacritty"; then
    echo "terminal-includes: $alacritty now imports dotfiles settings"
  else
    echo "terminal-includes: add $entry to general.import in $alacritty by hand" >&2
  fi
fi
