# Personal Neovim config

A batteries-included, IDE-like Neovim configuration -- LSP, debugging (DAP)
and test running for .NET, Go, Python and TypeScript/JavaScript, plus a
which-key/mini.nvim-based editing experience with a switchable fuzzy-finder
backend (Telescope or `snacks.nvim`'s picker, see `lua/config/picker.lua`).
Not a distribution meant for others to install as-is; this is my own config,
managed as part of [my dotfiles](../../../..) via [chezmoi](https://www.chezmoi.io/).

It started from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
but has since been restructured into a multi-file, LazyVim-style layout and
had its completion/LSP/debugging stacks replaced, so it no longer resembles
kickstart's single-file starting point.

## Layout

```
nvim/
├── init.lua              -- thin bootstrap: require's config.{options,keymaps,autocmds,lazy}
├── lua/
│   ├── config/
│   │   ├── options.lua   -- vim.opt/vim.g settings
│   │   ├── keymaps.lua   -- general (non-plugin-owned) keymaps
│   │   ├── autocmds.lua  -- yank highlight, etc.
│   │   ├── picker.lua    -- Telescope/snacks.picker backend switch + LSP/Harpoon wrappers
│   │   └── lazy.lua      -- lazy.nvim bootstrap + setup({ spec = { { import = "plugins" } } })
│   ├── plugins/          -- one file per plugin/feature, auto-imported by lazy.nvim
│   │   ├── lsp.lua       -- native vim.lsp.config()/vim.lsp.enable() for every server
│   │   ├── completion.lua-- blink.cmp
│   │   ├── telescope.lua -- Telescope picker backend (active when config/picker.lua's backend = 'telescope')
│   │   ├── snacks.lua    -- snacks.nvim picker backend + gitbrowse/bufdelete (active when backend = 'snacks')
│   │   ├── dap.lua       -- shared nvim-dap + nvim-dap-ui core, unified keymaps
│   │   ├── dap-dotnet.lua-- netcoredbg adapter + roslyn.nvim LSP
│   │   ├── dap-go.lua    -- delve adapter (nvim-dap-go)
│   │   ├── dap-python.lua-- debugpy adapter (nvim-dap-python)
│   │   ├── dap-js.lua    -- js-debug adapter (nvim-dap-vscode-js)
│   │   ├── neotest.lua   -- neotest + per-language adapters, dap strategy
│   │   └── ...           -- treesitter, mini.nvim, gitsigns, etc.
│   └── health.lua        -- :checkhealth checks tailored to this config
└── README.md
```

## Languages

| Language      | LSP                | Debugging (DAP)         | Tests (neotest)          |
| ------------- | ------------------ | ------------------------ | ------------------------- |
| C#/.NET       | `roslyn`            | `netcoredbg`              | `neotest-dotnet`           |
| Go            | `gopls`             | `delve` (`nvim-dap-go`)   | `neotest-go`               |
| Python        | `pyright` + `ruff`  | `debugpy`                 | `neotest-python`           |
| TypeScript/JS | `ts_ls`             | `js-debug-adapter`        | `neotest-jest`/`-vitest`   |

Plus `clangd`, `lua_ls`, `rust_analyzer` and `sourcekit` for editing this
config and other odds and ends.

Debug keymaps are shared across every language (Visual Studio/Rider-style):
`<F5>` continue, `<F10>` step over, `<F11>` step into, `<F8>` step out,
`<leader>b` toggle breakpoint. Test keymaps: `<leader>tr` run nearest,
`<leader>tf` run file, `<leader>ts` toggle summary, `<leader>td` debug
nearest test.

## Tooling

- Plugins: [lazy.nvim](https://github.com/folke/lazy.nvim)
- LSP servers/DAP adapters/formatters: installed via
  [mason.nvim](https://github.com/williamboman/mason.nvim) +
  [mason-tool-installer.nvim](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim)
  (see the `ensure_installed` list in `lua/plugins/lsp.lua`); run `:Mason` to
  check/manage installs.
- Completion: [blink.cmp](https://github.com/Saghen/blink.cmp)
- Picker shortcuts resolve from the current file's nearest Git root without
  changing Neovim's working directory. `<C-t>` uses Snacks' smart picker or
  Telescope's `find_files`, depending on the active backend.
- Run `:checkhealth` to verify the external tools (`git`, `rg`, `make`,
  per-language toolchains) this config expects are on `PATH`.

## Notes

This directory is chezmoi's source state for `~/.config/nvim`
(`home/dot_config/nvim` in the dotfiles repo); see the repo's top-level
`AGENTS.md` for the constraints that apply when editing it (no
organization-specific content, chezmoi source-attribute rules, etc.).
