_: {
  home = {
    sessionPath = [
      "$HOME/.local/bin"
    ];

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      SYSTEMD_EDITOR = "nvim";

      TERMINAL = "foot";

      HISTFILE = "$ZDOTDIR/.zsh_history";
      MOZ_LEGACY_PROFILES = "1";
      QT_QPA_PLATFORMTHEME = "qt6ct";
      NIX_PATH = "$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels\${NIX_PATH:+:$NIX_PATH}";

      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
    };
  };
}
