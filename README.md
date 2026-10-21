# Dotfiles (Arch Linux + Standalone Home Manager)

Konfigurasi dotfiles modular berbasis Nix Flakes dan Home Manager (standalone di Arch Linux).

## 📁 Struktur Repositori

```
.
├── flake.nix                # Flake entrypoint & inputs (follows home-manager, treefmt-nix)
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

## 🚀 Workflow & Perintah

### Menerapkan Konfigurasi

Untuk menerapkan perubahan Home Manager:

```bash
home-manager switch --flake .
```

### Format Seluruh Kode (Nix, Lua, Shell, Prettier)

Format otomatis seluruh file konfigurasi dengan treefmt terpadu:

```bash
nix fmt
```

### Development Shell

Direnv secara otomatis memuat environment saat masuk ke direktori repository (`.envrc` -> `use flake`).
Atau jalankan secara manual:

```bash
nix develop
```

Tersedia tool development: `nil`, `statix`, `lua-language-server`, serta alias perintah `format` dan `nixlint`.

### Manajemen Rahasia (Secrets)

File sensitif seperti API key tidak di-track oleh git.
Salin template dan isi key pribadi:

```bash
cp configs/zsh/secrets.zsh.example configs/zsh/secrets.zsh
```

`secrets.zsh` akan di-source otomatis oleh `configs/zsh/.zshenv` jika ada.
