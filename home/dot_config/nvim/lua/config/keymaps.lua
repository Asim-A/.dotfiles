vim.keymap.set('i', 'jk', '<Esc>')
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<cr>')

vim.keymap.set({ 'n', 'i' }, '<C-s>', '<cmd>w<cr>', { desc = 'save' })

vim.keymap.set('i', '<C-j>', '{}<Left>', { desc = '{' })
vim.keymap.set('i', '<C-k>', '[]<Left>', { desc = '[' })
vim.keymap.set('i', '<C-l>', '<Esc>la', { desc = 'Shift right' })
vim.keymap.set('i', '<C-h>', '<Esc>i', { desc = 'Shift left' })

vim.keymap.set('v', '<', '<gv', { desc = 'Indent left and reselect' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent left and reselect' })

-- NOTE: bare `s` intentionally stays as the built-in substitute command.
-- mini.surround owns multi-key `s`-prefixed sequences (sa/sd/sr/sf/sh/sn), so
-- Neovim briefly waits (up to 'timeoutlen') after a lone `s` to see whether a
-- surround sequence follows. That hesitation is structural to having both
-- substitute and mini.surround on the same `s` prefix - there used to be a
-- no-op `s -> s` remap here that didn't change this behavior, so it was removed.

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<M-n>', '<cmd>cnext<CR>')
vim.keymap.set('n', '<M-p>', '<cmd>cprev<CR>')
vim.keymap.set('n', 'gn', function()
  vim.diagnostic.jump { count = 1, float = true }
end)
vim.keymap.set('n', 'gp', function()
  vim.diagnostic.jump { count = -1, float = true }
end)

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- On Windows there is no tmux layer; WezTerm handles pane splits directly, so
-- pane navigation is delegated to the wezterm-move.nvim plugin instead (see
-- lua/plugins/pane-nav.lua). Elsewhere, vim-tmux-navigator's own default
-- <C-h/j/k/l> mappings provide seamless nvim<->tmux navigation, so these
-- native window-nav keymaps mainly serve as a plain-nvim fallback there.
if vim.fn.has 'win32' == 0 then
  vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
  vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
  vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
  vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
end
