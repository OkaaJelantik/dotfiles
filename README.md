# Dotfiles (Arch Linux + Standalone Home Manager)

Konfigurasi dotfiles modular berbasis Nix Flakes dan Home Manager (standalone di Arch Linux).

## 📁 Struktur Repositori

```
.
├── flake.nix                # Flake entrypoint & inputs (follows home-manager, nixfmt-tree)
├── flake.lock               # Lockfile dependensi yang di-pin
├── home.nix                 # Identity & system entry point
├── .envrc                   # Integrasi otomatis direnv
├── modules/
│   ├── default.nix          # Root module loader
│   ├── session.nix          # Single source of truth untuk PATH & environment variables
│   ├── desktop/             # Window manager & GUI (Sway, Waybar, Foot, Fuzzel, Rofi, SwayOSD)
│   ├── editor/              # Neovim (config link)
│   ├── shell/               # Zsh config link
│   └── tools/               # CLI & Development tools
│       ├── cli.nix          # devenv, lazydocker, lazygit, markitdown
│       ├── coding-agent.nix # graphify, litellm, tgrep, tgrep-mcp, nix-skills
│       └── media.nix        # iptv (packaged script), yt-dlp, aria2
└── configs/                 # File konfigurasi asli (di-symlink via mkOutOfStoreSymlink)
    ├── nvim/
    ├── sway/
    ├── waybar/
    ├── zsh/
    └── ...
```
