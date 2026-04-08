# My dotfiles

## Package groups

This repository is split into stow packages:
- `base` - user dirs and shared local bin scripts
- `shell` - bash/fish configuration
- `nvim` - Neovim configuration
- `wm` - niri/waybar/wofi/swaylock/alacritty/theme assets
- `media` - mpd/mpv/ncmpcpp
- `dev` - bun/vpn/dev tooling config

## Setup (recommended)

Use `just` as the entrypoint:
```
just install-deps
just stow-all
just check
```

Stow a single group:
```
just stow group=nvim
```

Restow or unstow a group:
```
just restow group=wm
just unstow group=media
```

## JS/TS tooling

Default JS/TS workflow uses `bun`:
- `ni` -> `bun install`
- `nr` -> `bun run`
- `nx` -> `bunx`

`npm` is shimmed to `bun` via `~/.local/bin/npm` for Mason and legacy scripts.

## Neovim

Requires **Neovim 0.12+** (built-in `vim.pack`). After `just stow group=nvim`, config lives under `~/.config/nvim/` from the `nvim/` package.

### Layout

- `init.lua` — loads `core.*`, then `core.bootstrap` → `require("plugins.pack").init()`.
- `lua/core/` — options, keymaps, diagnostics, theme, bootstrap.
- `lua/plugins/pack.lua` — single ordered `PLUGINS` list (`src`, `dependencies`, optional `name` / `opts` / `config` / `init`). `vim.pack.add(PLUGINS)` installs into `stdpath("data")/site/pack/core/opt`, then each entry is set up in list order.
- `lua/plugins/*.lua` — plugin-specific tables (`opts`, `config`, `init`) required from `pack.lua` (e.g. `lsp.lua`, `cmp.lua`, `copilot.lua`).

Lockfile: `~/.config/nvim/nvim-pack-lock.json` (optional to track in git; see `:h vim.pack`).

### blink.cmp (Rust fuzzy)

Fuzzy matching uses a native library built with **Cargo**. On `PackChanged` for `blink.cmp` (`install` / `update`), the config runs `cargo build --release` in the plugin directory. Ensure `cargo` is on `PATH`. Prebuilt downloads are disabled in opts; build locally or keep the binary in `target/release/`.

### GitHub Copilot

Proxy and Node env are configured in `lua/plugins/copilot.lua` (e.g. `COPILOT_HTTP_PROXY`, standard `HTTP(S)_PROXY`). Optional secrets: fish `secrets.fish` or `environment.d`; see comments in that file.

### Mason / LSP

- Mason UI / installs: `:Mason`, `:MasonInstall`, `:MasonUpdate`.
- Server list and overrides: `lua/plugins/lsp.lua`.

If `gopls` fails, install Go (e.g. `sudo pacman -S go`).

### Plugin updates (vim.pack)

Not Lazy — use:

```
:lua vim.pack.update()
```

Review the confirmation buffer, then `:write` to apply or quit to discard. Restart Neovim if needed.

### Quick checks

```
just doctor
just check
```
