# .dotfiles

Cross-platform macOS, Windows, and Debian server-core dotfiles managed with
[chezmoi](https://www.chezmoi.io/). One source tree is applied natively on
each platform - no GNU Stow or WSL required.

## Layout

This repo's [`.chezmoiroot`](.chezmoiroot) points chezmoi at the `home/`
directory, which is the actual managed source state. Everything outside
`home/` (this README, `.chezmoiroot`, `.gitignore`) is repo-only tooling and
is never applied to your `$HOME`.

Highlights:

- `home/dot_config/nvim` - single LazyVim-based Neovim config shared across
  all supported platforms. Yazi integration is disabled when its executable
  is unavailable.
- `home/dot_config/wezterm` - shared WezTerm config; OS-specific bits
  (default shell, leader-key pane splitting on Windows since there's no tmux
  there) are handled with chezmoi templating.
- `home/dot_config/tmux` - macOS/Debian only (WezTerm's own leader-key pane
  nav covers this on Windows).
- `home/dot_config/starship.toml` - single shared prompt, used by both zsh
  and PowerShell. Powerlevel10k has been retired.
- `home/dot_gitconfig.tmpl` - shared git identity/behavior, with an
  `[include] path = ~/.gitconfig.local` hook for machine-local settings (see
  below).
- `home/Documents/PowerShell/...` - Windows-only PowerShell profile, kept
  generic/shareable (Starship init, PSFzf keybindings, aliases, Volta PATH
  fix).

## Keeping this repo public-safe

This repo is public. Nothing organization/employer-specific (hostnames,
internal paths, internal tool names, work email, etc.) belongs in it, even
gitignored. Two generic, content-free local-override hooks exist for that
content instead, both of which point at plain per-machine files that are
never referenced by name/path from here:

- zsh: `~/.work-profile.zsh`, sourced from `dot_zshrc.tmpl` if it exists.
- PowerShell: `~/.work-profile.ps1`, dot-sourced from the PowerShell profile
  if it exists.
- git: `~/.gitconfig.local`, included from `dot_gitconfig.tmpl` if it exists
  (git silently ignores a missing `include.path`).

Keep any employer-specific scripts/config in a separate, private
repo/location and point one of the hook files above at it locally.

## Bootstrap

macOS:

```sh
chezmoi init --apply --source=~/git/.dotfiles
```

Windows (PowerShell):

```powershell
chezmoi init --apply --source=C:\git\.dotfiles
```

Debian 11 Bullseye VPS prerequisites and bootstrap:

```sh
sudo apt-get update
sudo apt-get install -y ca-certificates curl git
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
mkdir -p "$HOME/git"
git clone https://github.com/Asim-A/.dotfiles.git "$HOME/git/.dotfiles"
"$HOME/.local/bin/chezmoi" init --apply --source="$HOME/git/.dotfiles"
```

`chezmoi init` prompts once per machine (see `home/.chezmoi.toml.tmpl`) for
your git email, then applies the managed files. A
`run_once_after_install-packages-<os>` script installs the required tools
through Homebrew on macOS, winget on Windows, or apt plus verified user-local
releases on Debian. See `home/.chezmoidata.yaml` for the package manifests.

The Debian server-core profile installs Git, zsh, tmux, ripgrep, fzf,
trash-cli, build utilities, Neovim, Starship, Volta, and the current Node.js
LTS selected by Volta. Neovim and Starship live under `~/.local`, while Volta
owns Node under `~/.volta`. It does not install or apply WezTerm, Yazi,
IdeaVim, PowerShell, mise, .NET, Go, Python-specific toolchains, or desktop
clipboard/open utilities.

The Debian installer changes the login shell with `chsh`; zsh becomes active
on the next login. Bullseye reaches the end of LTS on 2026-08-31 and should be
upgraded independently of this bootstrap.

Windows additionally gets `XDG_CONFIG_HOME` set to `%USERPROFILE%\.config`
persistently, so Neovim/WezTerm/Yazi resolve the exact same `~/.config/...`
paths used on macOS/Linux.

After the initial bootstrap, pull in changes with:

```sh
chezmoi update
```
