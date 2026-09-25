# Environment variables for current session

# XDG-BASE-DIR
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# PATH
export PATH="$HOME/.local/share/../bin:$HOME/.local/bin:$PATH"

# Zsh
export HISTFILE="$ZDOTDIR/.zsh_history"

# Utilities
export EDITOR=nvim
export VISUAL=nvim
export SYSTEMD_EDITOR=nvim
export TERMINAL=foot

export QT_QPA_PLATFORMTHEME=qt6ct
export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels${NIX_PATH:+:$NIX_PATH}
