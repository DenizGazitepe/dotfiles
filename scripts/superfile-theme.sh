#!/usr/bin/env bash
# Point superfile's "omarchy" theme at the file Omarchy renders from the
# superfile stow package's template on every `omarchy theme set`. The template
# only renders on a theme change, so reapply the current theme (keeping its
# background) when the rendered file is missing. Safe to rerun.
set -euo pipefail

state="$HOME/.local/state/omarchy/current"
rendered="$state/theme/superfile.toml"
link="${XDG_CONFIG_HOME:-$HOME/.config}/superfile/theme/omarchy.toml"

mkdir -p "$(dirname "$link")"
ln -sfn "$rendered" "$link"

if [[ ! -f $rendered ]] && command -v omarchy >/dev/null && [[ -f $state/theme.name ]]; then
  echo "superfile-theme: rendering superfile.toml for the current Omarchy theme"
  OMARCHY_THEME_SKIP_BACKGROUND=1 omarchy theme set "$(<"$state/theme.name")"
fi
