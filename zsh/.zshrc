# Zsh for terminals. Ghostty starts it; bash stays Omarchy's stock login
# shell. This repeats the interactive parts of Omarchy's bash rc
# ($OMARCHY_PATH/default/bash) that are worth keeping.

# Environment
# The Hyprland session already exports OMARCHY_PATH and PATH; this covers a
# zsh started from anywhere else.
[[ -r /usr/share/omarchy/default/bash/env-bootstrap ]] &&
  emulate sh -c '. /usr/share/omarchy/default/bash/env-bootstrap'

export EDITOR="${EDITOR:-omarchy-launch-editor --inline}"
export SUDO_EDITOR="$EDITOR"
export BROWSER="${BROWSER:-omarchy-launch-browser}"
export MANROFFOPT="-c"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# History, appended as each command runs, like bash's histappend
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
[[ -d ${HISTFILE:h} ]] || mkdir -p "${HISTFILE:h}"
HISTSIZE=32768
SAVEHIST=$HISTSIZE
setopt extended_history inc_append_history hist_ignore_dups hist_ignore_space hist_reduce_blanks

setopt interactive_comments no_beep

# Key bindings
bindkey -e

# Up/Down match what you've typed so far against history (Omarchy's inputrc)
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search edit-command-line
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
zle -N edit-command-line
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[OA' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[OB' down-line-or-beginning-search
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^X^E' edit-command-line

# Completion. fzf-tab draws the menu, so zsh's own stays off.
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no
zstyle ':completion:*' rehash true
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*:git-checkout:*' sort false

zcompdump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$ZSH_VERSION"
[[ -d ${zcompdump:h} ]] || mkdir -p "${zcompdump:h}"
autoload -Uz compinit
compinit -d "$zcompdump"
unset zcompdump

# fzf-tab loads after compinit and before anything that wraps widgets.
# scripts/packages.sh clones it.
fzf_tab="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh"
[[ -r $fzf_tab ]] && source "$fzf_tab"
unset fzf_tab
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:complete:(cd|zd|z):*' fzf-preview 'eza -1 --color=always --icons=auto $realpath'

# Tools
(( $+commands[mise] )) && eval "$(mise activate zsh)"
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"

# Ctrl-R history, Ctrl-T files, Alt-C directories. Tab belongs to fzf-tab,
# so fzf's own ** completion is left out.
[[ -r /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh

if (( $+commands[try] )); then
  try() {
    unfunction try
    eval "$(SHELL=$commands[zsh] command try init ~/Work/tries)"
    try "$@"
  }
fi

# File system
if (( $+commands[eza] )); then
  alias ls='eza -lh --group-directories-first --icons=auto'
  alias lsa='ls -a'
  alias lt='eza --tree --level=2 --long --icons --git'
  alias lta='lt -a'
fi

alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
alias eff='${=EDITOR} "$(ff)"'
sff() {
  if (( $# == 0 )); then
    echo "Usage: sff <destination> (e.g. sff host:/tmp/)"
    return 1
  fi
  local file
  file=$(find . -type f -printf '%T@\t%p\n' | sort -rn | cut -f2- | ff) && [[ -n $file ]] && scp "$file" "$1"
}

if (( $+commands[zoxide] )); then
  alias cd='zd'
  zd() {
    if (( $# == 0 )); then
      builtin cd ~ || return
    elif [[ -d $1 ]]; then
      builtin cd "$1" || return
    else
      if ! z "$@"; then
        echo "Error: Directory not found"
        return 1
      fi
      printf "\U000F17A9 "
      pwd
    fi
  }
  compdef zd=cd
fi

open() {
  xdg-open "$@" >/dev/null 2>&1 &!
}

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Tools
alias a='omarchy-agent --inline'
alias c='opencode --auto'
alias ca='cursor-agent --force --approve-mcps'
alias cx='printf "\033[2J\033[3J\033[H" && claude --permission-mode auto'
alias cy='codex --approve-for-me'
alias d='docker'
alias r='rails'
alias t='tmux attach || tmux new -s Work'
alias h='herdr'
alias mup='MISE_MINIMUM_RELEASE_AGE=0 mise up'
n() { if (( $# == 0 )); then command nvim .; else command nvim "$@"; fi; }

# Git
alias g='git'
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gcad='git commit -a --amend'

# Prompt
(( $+commands[oh-my-posh] )) &&
  eval "$(oh-my-posh init zsh --config "${XDG_CONFIG_HOME:-$HOME/.config}/omp/zen.toml")"

# Grey inline suggestions from history; Right arrow or End accepts.
[[ -r /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] &&
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Syntax highlighting goes last, as zsh-patina's README asks.
(( $+commands[zsh-patina] )) && eval "$(zsh-patina activate)"
