# Omarchy environment (OMARCHY_PATH + PATH), needed even for non-interactive shells
[[ -r /usr/share/omarchy/default/bash/env-bootstrap ]] && source /usr/share/omarchy/default/bash/env-bootstrap

# User Omarchy wrappers (Cursor CLI as a coding agent) take precedence.
case ":$PATH:" in
  *":$HOME/.config/omarchy/bin:"*) ;;
  *) export PATH="$HOME/.config/omarchy/bin${PATH:+:$PATH}" ;;
esac

# If not running interactively, don't do anything else (leave this above the rc source)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source "$OMARCHY_PATH/default/bash/rc"

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'

# Cursor CLI, matching c/cx/cy auto-approve shortcuts
alias ca='cursor-agent --force --approve-mcps'

# Oh My Posh owns the prompt. Omarchy starts Starship inside the rc sourced
# above; give back the hook Starship replaced, then start Oh My Posh.
if command -v oh-my-posh >/dev/null; then
  if [[ -n ${STARSHIP_PROMPT_COMMAND+x} ]]; then
    if [[ -n $STARSHIP_PROMPT_COMMAND ]]; then
      PROMPT_COMMAND=$STARSHIP_PROMPT_COMMAND
    else
      unset PROMPT_COMMAND
    fi
  fi
  export OMP_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/oh-my-posh"
  mkdir -p "$OMP_CACHE_DIR"
  eval "$(oh-my-posh init bash --config "${XDG_CONFIG_HOME:-$HOME/.config}/omp/zen.toml" --print)"
fi
