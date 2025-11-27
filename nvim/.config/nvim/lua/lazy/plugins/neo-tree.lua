-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  event = 'VimEnter',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  config = function()
    require('neo-tree').setup {
      position = 'right',
      close_if_last_window = true,
      filesystem = {
        filtered_items = {
          visible = true,
          show_hidden_count = true,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
        never_show = { 'node_modules' },
      },
      buffers = { follow_current_file = { enable = true } },
    }
  end,
  cmd = 'Neotree',
  keys = {
    -- This will map <leader>e to toggle the tree as a standard command
    {
      '<C-e>',
      function()
        require('neo-tree.command').execute {
          position = 'right',
          close_if_last_window = true,
          filesystem = {
            filtered_items = {
              visible = true,
              show_hidden_count = true,
              hide_dotfiles = false,
              hide_gitignored = false,
            },
            follow_current_file = {
              enabled = true,
              leave_dirs_open = false,
            },
            never_show = { 'node_modules' },
          },
          buffers = { follow_current_file = { enable = true } },
        }
      end,
      desc = 'Neo-tree: Toggle Explorer',
    },
  },
  opts = {},
}
