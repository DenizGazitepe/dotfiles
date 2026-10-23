#!/usr/bin/env bash
# Optional. Run by hand to install the packages this overlay expects.
set -euo pipefail

omarchy pkg add stow bat git-delta eza fzf zoxide
omarchy pkg aur add oh-my-posh

# Zsh for terminals; bash stays Omarchy's login shell.
omarchy pkg add zsh zsh-autosuggestions zsh-completions
omarchy pkg aur add zsh-patina

# fzf-tab's AUR package is stale, so keep a clone pinned to a release tag.
fzf_tab_version=v1.3.0
fzf_tab_dir="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins/fzf-tab"
[[ -d $fzf_tab_dir/.git ]] || git clone --quiet https://github.com/Aloxaf/fzf-tab "$fzf_tab_dir"
git -C "$fzf_tab_dir" fetch --quiet --tags origin
git -C "$fzf_tab_dir" -c advice.detachedHead=false checkout --quiet "$fzf_tab_version"
