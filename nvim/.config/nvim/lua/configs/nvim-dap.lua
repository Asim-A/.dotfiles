local dap = require 'dap'
local console = require 'dapui.elements.console'

local data_path = vim.fn.stdpath 'data'
local netcoredbg_path = data_path .. '/lazy/netcoredbg-macOS-arm64.nvim/netcoredbg/netcoredbg'

local netcoredbg_adapter = {
  type = 'executable',
  command = netcoredbg_path,
  args = { '--interpreter=vscode' },
}

dap.adapters.netcoredbg = netcoredbg_adapter -- needed for normal debugging
dap.adapters.coreclr = netcoredbg_adapter -- needed for unit test debugging

dap.configurations.cs = {
  {
    type = 'coreclr',
    name = 'launch - netcoredbg',
    request = 'launch',
    program = function()
      return require('dap-dll-autopicker').build_dll_path()
    end,
    console = 'integrateTerminal',
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

local map = vim.keymap.set

local opts = { noremap = true, silent = true }

map('n', '<F5>', "<Cmd>lua require'dap'.continue()<CR>", opts)
map('n', '<F6>', "<Cmd>lua require('neotest').run.run({strategy = 'dap'})<CR>", opts)
map('n', '<leader>b', "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", opts)
map('n', '<F10>', "<Cmd>lua require'dap'.step_over()<CR>", opts)
map('n', '<F11>', "<Cmd>lua require'dap'.step_into()<CR>", opts)
map('n', '<F8>', "<Cmd>lua require'dap'.step_out()<CR>", opts)
-- map("n", "<F12>", "<Cmd>lua require'dap'.step_out()<CR>", opts)
map('n', '<leader>dr', "<Cmd>lua require'dap'.repl.open()<CR>", opts)
map('n', '<leader>dl', "<Cmd>lua require'dap'.run_last()<CR>", opts)
map('n', '<leader>dt', "<Cmd>lua require('neotest').run.run({strategy = 'dap'})<CR>", { noremap = true, silent = true, desc = 'debug nearest test' })
