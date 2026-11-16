# Sourced early by ~/.zshrc on Omarchy (mise.omarchy.toml deploys it).

# The Hyprland session already exports OMARCHY_PATH and PATH; this covers a
# zsh started from anywhere else.
[[ -r /usr/share/omarchy/default/bash/env-bootstrap ]] &&
  emulate sh -c '. /usr/share/omarchy/default/bash/env-bootstrap'

export EDITOR="${EDITOR:-omarchy-launch-editor --inline}"
export BROWSER="${BROWSER:-omarchy-launch-browser}"

alias a='omarchy-agent --inline'
