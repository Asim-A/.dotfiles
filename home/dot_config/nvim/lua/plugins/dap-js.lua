-- TypeScript/JavaScript debugging via vscode-js-debug (installed as Mason's
-- `js-debug-adapter` package, see plugins/lsp.lua). Adapter/config setup
-- only -- shared keymaps/UI live in plugins/dap.lua.
--
-- Launch configs below target plain Node.js scripts/processes (the most
-- common case for backend TS/JS work and for neotest-jest/neotest-vitest's
-- dap strategy); the `pwa-chrome` adapter is also registered so browser
-- debugging can be added later by appending a `request = 'launch', type =
-- 'pwa-chrome'` configuration per project.
return {
  'mxsdev/nvim-dap-vscode-js',
  ft = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
  dependencies = { 'mfussenegger/nvim-dap' },
  config = function()
    local mason_registry = require 'mason-registry'
    local js_debug_dir = mason_registry.get_package('js-debug-adapter'):get_install_path()

    require('dap-vscode-js').setup {
      debugger_path = js_debug_dir,
      adapters = { 'pwa-node', 'pwa-chrome', 'node' },
    }

    local dap = require 'dap'
    for _, language in ipairs { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' } do
      dap.configurations[language] = {
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch file',
          program = '${file}',
          cwd = '${workspaceFolder}',
        },
        {
          type = 'pwa-node',
          request = 'attach',
          name = 'Attach to process',
          processId = require('dap.utils').pick_process,
          cwd = '${workspaceFolder}',
        },
      }
    end
  end,
}
