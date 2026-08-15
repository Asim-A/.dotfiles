return {
  {
    'seblyng/roslyn.nvim',
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    ft = { 'cs', 'razor' },
    opts = {},
    dependencies = {
      {
        'tris203/rzls.nvim',
        config = true,
      },
      -- Debug adapter + dap.adapters/dap.configurations for C# below
      'mfussenegger/nvim-dap',
      -- Provides `dap-dll-autopicker`, used to find the built DLL to launch
      'ramboe/ramboe-dotnet-utils',
    },
    config = function()
      -- Use one of the methods in the Integration section to compose the command.
      local rzls_path = vim.fn.expand '$MASON/packages/rzls/libexec'
      local cmd = {
        'roslyn',
        '--stdio',
        '--logLevel=Information',
        '--extensionLogDirectory=' .. vim.fs.dirname(vim.lsp.log.get_filename()),
        '--razorSourceGenerator=' .. vim.fs.joinpath(rzls_path, 'Microsoft.CodeAnalysis.Razor.Compiler.dll'),
        '--razorDesignTimePath=' .. vim.fs.joinpath(rzls_path, 'Targets', 'Microsoft.NET.Sdk.Razor.DesignTime.targets'),
        '--extension',
        vim.fs.joinpath(rzls_path, 'RazorExtension', 'Microsoft.VisualStudioCode.RazorExtension.dll'),
      }

      vim.lsp.config('roslyn', {
        cmd = cmd,
        handlers = require 'rzls.roslyn_handlers',
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
