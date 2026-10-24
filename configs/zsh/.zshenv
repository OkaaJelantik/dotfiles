# Environment variables for current session

# Source Home Manager session variables if available
if [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
    source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
fi

# Fallback / explicit XDG and PATH
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export PATH="$HOME/.local/bin:$PATH"

# Zsh history
export HISTFILE="${HISTFILE:-$ZDOTDIR/.zsh_history}"

# Load optional local secrets (not tracked by git)
if [ -f "${ZDOTDIR:-$HOME/.config/zsh}/secrets.zsh" ]; then
    source "${ZDOTDIR:-$HOME/.config/zsh}/secrets.zsh"
fi
