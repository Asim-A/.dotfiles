-- Go debugging via delve, replacing the old lua/lazy/plugins/debug.lua
-- (which duplicated nvim-dap and had colliding keymaps with dap-dotnet.lua).
-- Adapter/config setup only -- shared keymaps/UI live in plugins/dap.lua.
return {
  'leoluz/nvim-dap-go',
  ft = 'go',
  dependencies = { 'mfussenegger/nvim-dap' },
  config = function()
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }
  end,
}
