# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Zinit plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Set up the prompt
autoload -Uz promptinit
promptinit
prompt adam1

autoload -U compinit
compinit

# Oh My Posh
eval "$(oh-my-posh init zsh --config ~/.config/omp/zen.toml)"

# Set FZF default options (catppuccin mocha theme)
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--multi"

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completions
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)


zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# Aliases
alias c='clear'
if command -v eza &> /dev/null; then
    alias ls='eza --group-directories-first'
    alias ll='eza -lhg --git --group-directories-first'
    alias lla='eza -alhg --git --group-directories-first'
    alias tree='eza --tree'
fi
if command -v bat &> /dev/null; then
    alias cat='bat --theme="Catppuccin Mocha"'
fi
if command -v fzf &> /dev/null && command -v bat &> /dev/null; then
    alias fzp='fzf --preview "bat --theme=\"Catppuccin Mocha\" --style=numbers --color=always {}"'
fi

# Shell integration
eval "$(zoxide init zsh --cmd cd)"
source <(fzf --zsh)
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
