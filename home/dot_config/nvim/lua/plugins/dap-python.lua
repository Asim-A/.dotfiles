-- Python debugging via debugpy (installed by mason-tool-installer, see
-- plugins/lsp.lua). Adapter/config setup only -- shared keymaps/UI live in
-- plugins/dap.lua.
return {
  'mfussenegger/nvim-dap-python',
  ft = 'python',
  dependencies = { 'mfussenegger/nvim-dap' },
  config = function()
    local mason_registry = require 'mason-registry'
    local debugpy_dir = mason_registry.get_package('debugpy'):get_install_path()
    local python_path = vim.fn.has 'win32' == 1 and debugpy_dir .. '/venv/Scripts/python.exe' or debugpy_dir .. '/venv/bin/python'

    require('dap-python').setup(python_path)
  end,
}
