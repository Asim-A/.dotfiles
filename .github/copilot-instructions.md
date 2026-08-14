# GitHub Copilot instructions for this repository

**Read [`/AGENTS.md`](../AGENTS.md) in full before making any change here.**
It is the canonical rules file for AI agents/assistants working in this
repo and takes precedence over general habits or assumptions. This file is
a short pointer/summary — `AGENTS.md` has the full detail and reasoning.

## Quick summary (see AGENTS.md for the complete, authoritative version)

- **This repo is public.** Never commit organization/employer-specific
  content — hostnames, internal paths, internal tool names, work email
  defaults — not even gitignored. That kind of content belongs in a
  separate private repo, referenced from here only via generic,
  content-free hooks (`~/.work-profile.zsh`, `~/.work-profile.ps1`,
  `~/.gitconfig.local`) that just check "does this file exist?".
- This is a [chezmoi](https://www.chezmoi.io/) source directory with
  `.chezmoiroot` pointing at `home/`. Only `home/` is the managed source
  state; everything else at the repo root is repo-only tooling.
- chezmoi filename attributes (`run_`, `once_`, `after_`, `dot_`, etc.) must
  use the exact prefixes/order from
  https://www.chezmoi.io/reference/source-state-attributes/. An
  unrecognized attribute segment is **not** an error — it's silently kept
  as a literal filename character, so a typo produces the wrong behavior
  with no warning. Verify any change with `chezmoi diff`/`chezmoi status`,
  never by inspection alone.
- `.chezmoiignore` patterns must match the *stripped target name* chezmoi
  computes after removing recognized attributes/`.tmpl`, not the raw source
  filename.
- Before treating any change as done: run `chezmoi diff`, `chezmoi status`
  (should be clean or show only expected pending items), `luac -p` on any
  edited Lua file, and a final grep of `home/` for organization-specific
  strings if the change touches anything public-facing.
- Preserve git history on any restructuring — use `git mv`, not
  delete-and-recreate.

If anything here conflicts with `AGENTS.md`, `AGENTS.md` wins.
