return {
  {
    'seblyng/roslyn.nvim',
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    ft = { 'cs', 'razor' },
    dependencies = {
      -- Debug adapter + dap.adapters/dap.configurations for C# below
      'mfussenegger/nvim-dap',
      -- Provides `dap-dll-autopicker`, used to find the built DLL to launch
      'ramboe/ramboe-dotnet-utils',
    },
    config = function()
      -- NOTE: as of recent roslyn.nvim releases, Razor/CSHTML support is
      -- built into the `roslyn` language server itself via co-hosting, which
      -- supersedes the old separate `rzls`/`rzls.nvim` server+plugin (see
      -- https://github.com/seblyng/roslyn.nvim#razorcshtml-support). That
      -- means roslyn.nvim now resolves its own `cmd` (it looks for the
      -- Mason-installed `roslyn`/`roslyn-language-server` binary itself, see
      -- `roslyn.utils.get_roslyn_lsp_path`), so we no longer need to hand it
      -- a manually-built `cmd` with `--razorSourceGenerator`/`--extension`
      -- flags pointing at a separate `rzls` Mason package -- that package no
      -- longer exists in the registry, which silently broke `gd`/definition
      -- lookups (the `roslyn` client never started).
      require('roslyn').setup {}

      vim.lsp.config('roslyn', {
        settings = {
          ['csharp|inlay_hints'] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,

            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            csharp_enable_inlay_hints_for_types = true,
            dotnet_enable_inlay_hints_for_indexer_parameters = true,
            dotnet_enable_inlay_hints_for_literal_parameters = true,
            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
            dotnet_enable_inlay_hints_for_other_parameters = true,
            dotnet_enable_inlay_hints_for_parameters = true,
            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
          },
          ['csharp|code_lens'] = {
            dotnet_enable_references_code_lens = true,
          },
        },
      })
      vim.lsp.enable 'roslyn'

      -- .NET debugging (netcoredbg). This file only lazy-loads on `cs`/`razor`
      -- filetypes, so it's a natural place to register the adapter alongside
      -- the LSP -- the shared dap/dapui/keymap core lives in plugins/dap.lua.
      local dap = require 'dap'

      -- netcoredbg is installed by mason-tool-installer (see plugins/lsp.lua),
      -- which prepends Mason's bin dir to `PATH`. Resolving it with
      -- `vim.fn.exepath` (rather than a hardcoded plugin-install path) keeps
      -- this working on Windows/Linux/macOS alike, unlike the previous
      -- `netcoredbg-macOS-arm64.nvim`-only path.
      local function netcoredbg_cmd()
        local cmd = vim.fn.exepath 'netcoredbg'
        if cmd == '' then
          vim.notify('netcoredbg not found on PATH -- install it via :Mason', vim.log.levels.WARN)
        end
        return cmd
      end

      local netcoredbg_adapter = {
        type = 'executable',
        command = netcoredbg_cmd(),
        args = { '--interpreter=vscode' },
      }

      dap.adapters.netcoredbg = netcoredbg_adapter -- needed for normal debugging
      dap.adapters.coreclr = netcoredbg_adapter -- needed for unit test debugging (neotest-dotnet)

      dap.configurations.cs = {
        {
          type = 'coreclr',
          name = 'launch - netcoredbg',
          request = 'launch',
          program = function()
            return require('dap-dll-autopicker').build_dll_path()
          end,
          console = 'integratedTerminal',
          justMyCode = false,
          stopAtEntry = false,
          env = {
            ASPNETCORE_ENVIRONMENT = function()
              return 'Development'
            end,
            ASPNETCORE_URLS = function()
              return 'http://localhost:5050'
            end,
          },
        },
      }
    end,
    init = function()
      -- We add the Razor file types before the plugin loads.
      vim.filetype.add {
        extension = {
          razor = 'razor',
          cshtml = 'razor',
        },
      }
    end,
  },
}
