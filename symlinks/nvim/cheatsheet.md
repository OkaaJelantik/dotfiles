# Neovim Coding Cheatsheet

> **Leader Key**: `Space` (`<leader>`)

---

## 1. LSP & Coding Intelligence

| Keymap       | Mode | Deskripsi                                |
| :----------- | :--: | :--------------------------------------- |
| `<leader>gd` | `n`  | Go to Definition (fzf picker)            |
| `<leader>gD` | `n`  | Go to Definition (langsung lompat)       |
| `<leader>gS` | `n`  | Go to Definition di vertical split       |
| `K`          | `n`  | Hover documentation / function signature |
| `<leader>ca` | `n`  | Code Actions (quick fixes, refactor)     |
| `<leader>rn` | `n`  | Rename symbol (variabel/fungsi/tipe)     |
| `<leader>oi` | `n`  | Organize imports & format buffer         |
| `<leader>fr` | `n`  | Find references (semua pemakaian simbol) |
| `<leader>ft` | `n`  | Find type definitions                    |
| `<leader>fs` | `n`  | Find symbols di dokumen saat ini         |
| `<leader>fw` | `n`  | Find symbols di seluruh workspace        |
| `<leader>fi` | `n`  | Find implementations                     |

---

## 2. Diagnostics & Errors

| Keymap                     | Mode | Deskripsi                                       |
| :------------------------- | :--: | :---------------------------------------------- |
| `<leader>d`                | `n`  | Tampilkan detail error di posisi kursor (float) |
| `<leader>D` / `<leader>dl` | `n`  | Tampilkan detail error di baris ini             |
| `<leader>nd`               | `n`  | Lompat ke error/warning berikutnya              |
| `<leader>pd`               | `n`  | Lompat ke error/warning sebelumnya              |
| `<leader>fx`               | `n`  | Daftar error di file saat ini (fzf)             |
| `<leader>fX`               | `n`  | Daftar error di seluruh project (fzf)           |
| `<leader>q`                | `n`  | Buka location list diagnostik                   |
| `<leader>td`               | `n`  | Toggle sembunyikan/tampilkan inline diagnostic  |

---

## 3. Autocomplete & Snippets (`blink.cmp`)

| Keymap      | Mode | Deskripsi                                |
| :---------- | :--: | :--------------------------------------- |
| `<C-Space>` | `i`  | Buka / tutup menu autocomplete           |
| `<C-j>`     | `i`  | Pilih item berikutnya                    |
| `<C-k>`     | `i`  | Pilih item sebelumnya                    |
| `<CR>`      | `i`  | Accept saran yang dipilih                |
| `<Tab>`     | `i`  | Lompat ke placeholder snippet berikutnya |
| `<S-Tab>`   | `i`  | Lompat ke placeholder snippet sebelumnya |

---

## 4. Pencarian & File Navigation

| Keymap       | Mode | Deskripsi                                |
| :----------- | :--: | :--------------------------------------- |
| `<leader>e`  | `n`  | Toggle file explorer (NvimTree)          |
| `<leader>ff` | `n`  | Cari file berdasarkan nama (fzf)         |
| `<leader>fg` | `n`  | Live grep (cari teks di seluruh project) |
| `<leader>fb` | `n`  | Cari buffer yang sedang terbuka          |
| `<leader>fh` | `n`  | Cari dokumentasi / help tags             |
| `<leader>bn` | `n`  | Pindah ke buffer berikutnya              |
| `<leader>bp` | `n`  | Pindah ke buffer sebelumnya              |
| `<leader>pa` | `n`  | Salin full file path ke clipboard        |

---

## 5. Editing & Text Manipulation

| Keymap             |   Mode    | Deskripsi                                               |
| :----------------- | :-------: | :------------------------------------------------------ |
| `<A-j>` / `<A-k>`  | `n` / `v` | Geser baris / blok seleksi ke atas / bawah              |
| `<` / `>`          |    `v`    | Indentasi kiri / kanan (seleksi tetap aktif)            |
| `<leader>p`        |    `v`    | Paste tanpa menimpa isi clipboard/register              |
| `<leader>x`        | `n` / `v` | Hapus teks ke blackhole register (tanpa yank)           |
| `J`                |    `n`    | Gabung baris berikutnya dan tahan posisi kursor         |
| `gc` / `gcc`       | `v` / `n` | Toggle komentar (mini.comment + treesitter)             |
| `sa` / `sd` / `sr` | `n` / `v` | Add, delete, replace tanda kurung/kutip (mini.surround) |
| `<leader>c`        |    `n`    | Bersihkan highlight pencarian (`:nohlsearch`)           |
| `<C-d>` / `<C-u>`  |    `n`    | Scroll setengah layar (auto-center)                     |
| `n` / `N`          |    `n`    | Hasil pencarian berikutnya/sebelumnya (auto-center)     |

---

## 6. Git Hunks & Navigation (`mini.diff` & `mini.git`)

| Keymap       | Mode | Deskripsi                            |
| :----------- | :--: | :----------------------------------- |
| `]h`         | `n`  | Lompat ke git hunk berikutnya        |
| `[h`         | `n`  | Lompat ke git hunk sebelumnya        |
| `<leader>hs` | `n`  | Stage git hunk di kursor             |
| `<leader>hp` | `n`  | Preview overlay perubahan hunk       |
| `<leader>hb` | `n`  | Git blame / riwayat commit baris ini |

---

## 7. Windows & Splits (`vim-tmux-navigator`)

| Keymap                   | Mode | Deskripsi                                      |
| :----------------------- | :--: | :--------------------------------------------- |
| `<C-h>` / `<C-j>`        | `n`  | Pindah ke pane kiri / bawah (seamless dg Tmux) |
| `<C-k>` / `<C-l>`        | `n`  | Pindah ke pane atas / kanan (seamless dg Tmux) |
| `<leader>sv`             | `n`  | Split window vertikal                          |
| `<leader>sh`             | `n`  | Split window horizontal                        |
| `<C-Up>` / `<C-Down>`    | `n`  | Ubah tinggi window                             |
| `<C-Left>` / `<C-Right>` | `n`  | Ubah lebar window                              |

---

## 8. Tools & Obsidian

| Keymap       | Mode | Deskripsi                                  |
| :----------- | :--: | :----------------------------------------- |
| `<leader>t`  | `n`  | Toggle floating terminal                   |
| `<C-q>`      | `t`  | Tutup floating terminal                    |
| `<Esc>`      | `t`  | Keluar mode insert terminal ke normal mode |
| `<leader>nn` | `n`  | Buat catatan baru (Obsidian)               |
| `<leader>nf` | `n`  | Cari judul catatan (quick switch)          |
| `<leader>ns` | `n`  | Cari teks di dalam catatan                 |
| `<leader>nt` | `n`  | Buka daily note hari ini                   |
