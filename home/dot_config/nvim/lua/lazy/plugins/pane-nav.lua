-- Pane navigation across the editor/multiplexer boundary is OS-specific:
-- Windows has no tmux, so WezTerm's own wezterm-move.nvim plugin is used to
-- cross from an nvim split into a WezTerm pane; Mac/Linux use tmux (via
-- dot_config/tmux), where vim-tmux-navigator's default <C-h/j/k/l> mappings
-- already provide the same seamless crossing.
if vim.fn.has 'win32' == 1 then
  return {
    'letieu/wezterm-move.nvim',
    keys = {
      { '<C-h>', function() require('wezterm-move').move 'h' end },
      { '<C-j>', function() require('wezterm-move').move 'j' end },
      { '<C-k>', function() require('wezterm-move').move 'k' end },
      { '<C-l>', function() require('wezterm-move').move 'l' end },
    },
  }
end

return {
  {
    'christoomey/vim-tmux-navigator',
    config = function() end,
  },
}
