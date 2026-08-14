# AGENTS.md

**Any AI agent or assistant must read this file in full before making any
change to this repository.** It encodes hard constraints and non-obvious
gotchas discovered while migrating this repo from GNU Stow to chezmoi.
Violating them silently breaks the dotfiles or leaks employer-specific data
into a public repo.

## 1. This repo is public. Zero tolerance for org-specific content.

Nothing organization/employer-specific may ever be committed here, **not
even gitignored** — hostnames, internal paths, internal tool/repo names,
credentials, or a work email address as a hardcoded default.

- Before proposing any commit, grep the full diff for things like internal
  domains, internal server/host names, employer tool names, and internal
  repo names. If you don't know what these look like for this user, ask
  before committing rather than guessing.
- The user's own name/GitHub username in `dot_gitconfig.tmpl` is fine —
  that's personal identity, not an org leak.
- All employer-specific logic (work aliases, internal paths, VPN/TFS/etc.)
  belongs in a **separate private repo**, never referenced by name, path,
  or hostname from this repo. This repo only exposes generic, content-free
  "local override" hooks that check for a file's existence and source it if
  present:
  - zsh: `~/.work-profile.zsh` (sourced from `dot_zshrc.tmpl`)
  - PowerShell: `~/.work-profile.ps1` (dot-sourced from the profile)
  - git: `~/.gitconfig.local` (via `[include] path = ~/.gitconfig.local` —
    git silently ignores a missing include path, so this is always safe to
    keep even when the file doesn't exist yet)

  Do not add a fourth hook that embeds any hint of what the private content
  actually is.

## 2. Layout: `.chezmoiroot` redirects everything into `home/`

`.chezmoiroot` contains `home`, so **only files under `home/`** are chezmoi's
managed source state. Files at the repo root (`README.md`, `.chezmoiroot`,
`.gitignore`, this file) are repo-only tooling and are never applied to
`$HOME`. Do not move managed dotfiles content to the repo root, and do not
put repo tooling under `home/`.

## 3. chezmoi filename attributes are strict and fail silently

chezmoi encodes behavior in source filenames via prefixes/suffixes, parsed
in a fixed order. **Unrecognized attribute segments are NOT rejected — they
are silently treated as literal filename characters**, so a typo doesn't
error, it just quietly does the wrong thing.

The one that already bit us: script attributes must be `run_`, then
`once_` or `onchange_`, then `before_` or `after_`, e.g.
`run_once_after_install-packages-windows.ps1.tmpl`. A file named
`run_onceafter_...` (no underscore, wrong order) is NOT a "run once after"
script — chezmoi only recognizes `run_` there and treats the rest,
including `onceafter_`, as part of the literal name. That means it silently
becomes a "run on every apply" script instead of "run once", and any
`.chezmoiignore` entry written against the *source* filename won't match
the *target* name chezmoi actually uses (see next point) — so an
OS-specific script can end up executing on the wrong OS with no error at
all.

**Whenever you add or rename a `run_`/`dot_`/`private_`/etc. file:**
1. Check https://www.chezmoi.io/reference/source-state-attributes/ for the
   exact allowed prefix set and order for that target type.
2. After the change, run `chezmoi status` / `chezmoi diff` (see §6) and
   confirm the displayed target name and behavior are what you intended —
   don't just trust the source filename.

## 4. `.chezmoiignore` entries must use the stripped *target* name

Entries in `.chezmoiignore`/`.chezmoiignore.tmpl` are matched against the
target path chezmoi computes **after stripping recognized attributes**
(`run_`, `once_`, `after_`, `dot_`, the `.tmpl` suffix, etc.), not the raw
source filename. E.g. the source file
`run_once_after_install-packages-windows.ps1.tmpl` must be excluded via the
line `install-packages-windows.ps1`, not
`run_once_after_install-packages-windows.ps1.tmpl`. Always verify with
`chezmoi status`/`chezmoi diff` on both a simulated Windows and
macOS/Linux `.chezmoi.os` value (or by re-running `chezmoi init` on the
actual target OS) that the intended file is actually excluded, since a
wrong/stale pattern fails silently (no error, it just doesn't match).

## 5. `sourceDir` / `.chezmoiroot` interaction is non-obvious

`.chezmoi.sourceDir` (as seen inside templates) resolves **past**
`.chezmoiroot` — it points at `home/`, not the repo root. `home/.chezmoi.toml.tmpl`
persists a `sourceDir` config value by stripping the trailing `/home` back
off, so that a plain `chezmoi apply`/`diff`/`update` (no `-S` flag) keeps
targeting this in-place clone. If you ever change how `.chezmoi.toml.tmpl`
computes `sourceDir`, re-run `chezmoi init --source=<repo path>
--promptDefaults`, then confirm `chezmoi source-path` (with **no** `-S`
flag) still resolves to `<repo path>/home` — don't assume it works from
reading the template alone.

## 6. Always validate before considering a change done

- `chezmoi diff` (or `chezmoi diff -x scripts` to skip triggering
  install scripts) to preview exactly what would change, for **every**
  edit that touches a templated or managed file.
- For Lua files: `luac -p <file>` to catch syntax errors before they reach
  a real Neovim/WezTerm config load.
- For WezTerm config changes: `wezterm --config-file <path> ls-fonts
  --list-system` will actually parse the whole config and surface Lua
  errors, without opening a GUI window.
- For Neovim config changes: `nvim --headless -c "qa"` should exit 0 with
  no errors printed.
- `chezmoi status` should be empty (or show only expected/intentional
  pending script runs) before you call a task finished.
- Before any push: grep the entire `home/` tree for organization-specific
  strings per §1. This is a hard gate, not a suggestion.

## 7. Preserve git history on restructuring

Use `git mv` (or edits that git detects as renames) rather than delete +
recreate, so `git log --follow` keeps working on every file that moves.

## 8. Platform scoping conventions already established

- macOS/Linux only: `dot_zshrc.tmpl`, `dot_config/tmux/*`.
- Windows only: `Documents/PowerShell/Microsoft.PowerShell_profile.ps1.tmpl`,
  Windows-only leader-key pane splitting in the WezTerm config (tmux already
  owns `Ctrl-a` elsewhere, so don't add this on macOS/Linux).
- Shared everywhere: `dot_config/nvim`, `dot_config/wezterm`,
  `dot_config/yazi`, `dot_config/starship.toml`, `dot_gitconfig.tmpl`.
- Prompt is Starship everywhere. Do not reintroduce Powerlevel10k or any
  other prompt tool — `zinit` (zsh) stays, but only for plugins
  (syntax-highlighting, autosuggestions, completions), never the prompt.
- `XDG_CONFIG_HOME` is set persistently on Windows so Neovim/WezTerm/Yazi
  resolve `~/.config/...` identically to macOS/Linux. Be aware WezTerm on
  Windows prioritizes a loose `%USERPROFILE%\.wezterm.lua` over
  `$XDG_CONFIG_HOME\wezterm\wezterm.lua` — if you ever see WezTerm not
  picking up config changes, check for and remove that loose file before
  assuming the template is broken.
- `home/dot_config/nvim/dot_gitignore`'s `lazy-lock.json` entry, and the
  matching `.chezmoiignore.tmpl` entry, are both intentional — the plugin
  lockfile is machine-specific churn that chezmoi should never own.

## 9. Do not add new tooling for this repo's own sake

Don't introduce new linters/build systems/test frameworks for this repo
without being asked. Validation is the checks in §6, which already exist
and are sufficient.
