-- Consolidated test runner across .NET, Go, Python and TS/JS, replacing the
-- ad-hoc neotest wiring that used to live inline in dap-dotnet.lua. One
-- consistent set of <leader>t* keymaps works for every adapter below.
return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'mfussenegger/nvim-dap',
    -- Per-language adapters
    'Issafalcon/neotest-dotnet',
    'nvim-neotest/neotest-go',
    'nvim-neotest/neotest-python',
    'nvim-neotest/neotest-jest',
    'marilari88/neotest-vitest',
  },
  config = function()
    require('neotest').setup {
      adapters = {
        require 'neotest-dotnet',
        require 'neotest-go',
        require 'neotest-python',
        require 'neotest-jest',
        require 'neotest-vitest',
      },
    }

    local neotest = require 'neotest'
    local map = vim.keymap.set

    map('n', '<leader>tr', function()
      neotest.run.run()
    end, { desc = '[T]est [R]un Nearest' })

    map('n', '<leader>tf', function()
      neotest.run.run(vim.fn.expand '%')
    end, { desc = '[T]est Run [F]ile' })

    map('n', '<leader>ts', function()
      neotest.summary.toggle()
    end, { desc = '[T]est Toggle [S]ummary' })

    map('n', '<leader>td', function()
      neotest.run.run { strategy = 'dap' }
    end, { desc = '[T]est [D]ebug Nearest' })

    map('n', '<leader>to', function()
      neotest.output_panel.toggle()
    end, { desc = '[T]est Toggle [O]utput Panel' })
  end,
}
