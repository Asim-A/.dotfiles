-- Shared nvim-dap core: adapters/configurations for each language live in
-- plugins/dap-dotnet.lua, plugins/dap-go.lua, plugins/dap-python.lua and
-- plugins/dap-js.lua, but the UI, virtual-text and keymaps below are common
-- to all of them so there is exactly one debugging mental model to learn,
-- loosely mirroring JetBrains Rider's integrated debugger keymaps:
--   F5 continue, F10 step over, F11 step into, F8 step out.
return {
  'mfussenegger/nvim-dap',
  dependencies = {
    { -- Debugger UI (breakpoints, scopes, REPL, stacks, watches)
      'rcarriga/nvim-dap-ui',
      dependencies = { 'nvim-neotest/nvim-nio' },
    },
    -- Shows variable values as inline virtual text while debugging
    'theHamsta/nvim-dap-virtual-text',
    -- Debug adapter binaries (netcoredbg, delve, debugpy, js-debug-adapter)
    -- are installed via mason-tool-installer in plugins/lsp.lua
    'williamboman/mason.nvim',
  },
  keys = {
    {
      '<F5>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Continue',
    },
    {
      '<F10>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<F11>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<F8>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>b',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>B',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set Conditional Breakpoint',
    },
    {
      '<leader>dr',
      function()
        require('dap').repl.open()
      end,
      desc = 'Debug: Open REPL',
    },
    {
      '<leader>dl',
      function()
        require('dap').run_last()
      end,
      desc = 'Debug: Run Last',
    },
    {
      '<leader>du',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: Toggle UI',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('nvim-dap-virtual-text').setup {}

    vim.fn.sign_define('DapBreakpoint', {
      text = '⚪',
      texthl = 'DapBreakpointSymbol',
      linehl = 'DapBreakpoint',
      numhl = 'DapBreakpoint',
    })
    vim.fn.sign_define('DapStopped', {
      text = '🔴',
      texthl = 'yellow',
      linehl = 'DapBreakpoint',
      numhl = 'DapBreakpoint',
    })
    vim.fn.sign_define('DapBreakpointRejected', {
      text = '⭕',
      texthl = 'DapStoppedSymbol',
      linehl = 'DapBreakpoint',
      numhl = 'DapBreakpoint',
    })

    dapui.setup {
      expand_lines = true,
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        enabled = true,
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
      floating = { border = 'rounded' },
      render = {
        max_type_length = 60,
        max_value_lines = 200,
      },
      layouts = {
        {
          elements = {
            { id = 'scopes', size = 0.5 },
            { id = 'repl', size = 0.5 },
          },
          size = 15,
          position = 'bottom', -- "left", "right", "top", "bottom"
        },
      },
    }

    -- Automatically open/close the UI as debug sessions start/stop
    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close
  end,
}
