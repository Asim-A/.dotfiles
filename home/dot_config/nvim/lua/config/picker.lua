-- Single switch point between nvim-telescope/telescope.nvim
-- (plugins/telescope.lua) and folke/snacks.nvim's picker module
-- (plugins/snacks.lua). Flip `M.backend` below and reload (`:Lazy reload` or
-- restart) to swap fuzzy-finder backends - every keymap defined in either of
-- those two plugin specs, plus the LSP (plugins/lsp.lua) and Harpoon
-- (plugins/harpoon.lua) wrappers below, keeps working identically no matter
-- which backend is active.
local M = {}

M.backend = 'snacks' -- 'telescope' | 'snacks'

function M.is_telescope()
  return M.backend == 'telescope'
end

function M.is_snacks()
  return M.backend == 'snacks'
end

function M.current_project_root()
  local buffer_name = vim.api.nvim_buf_get_name(0)
  if buffer_name == '' then
    return vim.fn.getcwd()
  end

  local file_path = vim.fs.normalize(vim.fn.fnamemodify(buffer_name, ':p'))
  local file_dir = vim.fs.dirname(file_path)
  local git_dir = vim.fs.find('.git', { path = file_dir, upward = true })[1]

  return git_dir and vim.fs.dirname(git_dir) or file_dir
end

-- LSP wrappers used by the LspAttach keymaps in plugins/lsp.lua -----------

function M.lsp_definitions()
  if M.is_snacks() then
    require('snacks').picker.lsp_definitions()
  else
    require('telescope.builtin').lsp_definitions()
  end
end

function M.lsp_references()
  if M.is_snacks() then
    require('snacks').picker.lsp_references()
  else
    require('telescope.builtin').lsp_references()
  end
end

function M.lsp_implementations()
  if M.is_snacks() then
    require('snacks').picker.lsp_implementations()
  else
    require('telescope.builtin').lsp_implementations()
  end
end

function M.lsp_type_definitions()
  if M.is_snacks() then
    require('snacks').picker.lsp_type_definitions()
  else
    require('telescope.builtin').lsp_type_definitions()
  end
end

function M.lsp_document_symbols()
  if M.is_snacks() then
    require('snacks').picker.lsp_symbols()
  else
    require('telescope.builtin').lsp_document_symbols()
  end
end

function M.lsp_workspace_symbols()
  if M.is_snacks() then
    require('snacks').picker.lsp_workspace_symbols()
  else
    require('telescope.builtin').lsp_dynamic_workspace_symbols()
  end
end

-- Harpoon wrapper used by the <leader>sm keymap in plugins/harpoon.lua ----
--
-- Builds a one-off picker over the current Harpoon marks. The telescope
-- branch is the previous inline `toggle_telescope` helper, moved here
-- unchanged; the snacks branch feeds the same file list into
-- `Snacks.picker.pick`.
function M.harpoon_marks(harpoon_list)
  local file_paths = {}
  for _, item in ipairs(harpoon_list.items) do
    table.insert(file_paths, item.value)
  end

  if M.is_snacks() then
    local items = {}
    for _, path in ipairs(file_paths) do
      table.insert(items, { text = path, file = path })
    end

    require('snacks').picker.pick {
      source = 'harpoon',
      title = 'Harpoon',
      items = items,
      format = 'file',
    }
    return
  end

  local conf = require('telescope.config').values
  require('telescope.pickers')
    .new({}, {
      prompt_title = 'Harpoon',
      finder = require('telescope.finders').new_table {
        results = file_paths,
      },
      previewer = conf.file_previewer {},
      sorter = conf.generic_sorter {},
    })
    :find()
end

return M
