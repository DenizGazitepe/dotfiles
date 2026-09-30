#!/usr/bin/env bash
# Optional. Run by hand to install the packages this overlay expects.
set -euo pipefail

omarchy pkg add stow bat git-delta eza fzf zoxide
omarchy pkg aur add oh-my-posh
