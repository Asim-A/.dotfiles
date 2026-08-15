return { -- QoL utility bundle from folke; its `picker` module doubles as an
  -- opt-in alternative to Telescope (plugins/telescope.lua) - see
  -- lua/config/picker.lua for the single switch point between the two.
  'folke/snacks.nvim',
  lazy = false, -- snacks needs to load its autocmds unconditionally
  priority = 1000,
  dependencies = {
    -- Useful for getting pretty icons, but requires a Nerd Font.
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  opts = {
    picker = {
      enabled = true,
      -- Only take over vim.ui.select (e.g. code actions) while snacks is
      -- the active picker backend; telescope-ui-select owns it otherwise.
      ui_select = require('config.picker').is_snacks(),
    },
    -- Scaffolded but deliberately left off: enabling `explorer` would fight
    -- with yazi.nvim's file manager (<leader>e, plugins/yazi.lua), and
    -- enabling `notifier` would fight with noice.nvim's message UI
    -- (plugins/noice.lua). Flipping either on is a separate, later
    -- experiment - just change `enabled` here.
    explorer = { enabled = false },
    notifier = { enabled = false },
  },
  config = function(_, opts)
    local Snacks = require 'snacks'
    Snacks.setup(opts)

    -- Mirrors plugins/telescope.lua's <leader>s*/<C-f> keymaps 1:1, only
    -- registered while snacks is the active picker backend so the two
    -- plugins never fight over the same keys.
    if require('config.picker').is_snacks() then
      vim.keymap.set('n', '<leader>sh', function()
        Snacks.picker.help()
      end, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', function()
        Snacks.picker.keymaps()
      end, { desc = '[S]earch [K]eymaps' })

      vim.keymap.set('n', '<leader>sf', function()
        Snacks.picker.files()
      end, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ff', function()
        Snacks.picker.files { hidden = true }
      end, { desc = '[S]earch [A]ll [F]iles (including hidden)' })

      vim.keymap.set('n', '<leader>ss', function()
        Snacks.picker()
      end, { desc = '[S]earch [S]elect Snacks picker' })

      vim.keymap.set('v', '♠', function()
        Snacks.picker.grep_word()
      end, { desc = 'Find visual selection' })
      vim.keymap.set('n', '<leader>sw', function()
        Snacks.picker.grep_word()
      end, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '♠', function() -- gamechanger
        Snacks.picker.grep { hidden = true }
      end, { desc = '[S]earch [A]ll [F]iles (including hidden)' })

      vim.keymap.set('n', '<leader>sd', function()
        Snacks.picker.diagnostics()
      end, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', function()
        Snacks.picker.resume()
      end, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', function()
        Snacks.picker.recent()
      end, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', function()
        Snacks.picker.buffers()
      end, { desc = '[ ] Find existing buffers' })

      -- Current-buffer fuzzy find (mirrors Telescope's current_buffer_fuzzy_find)
      vim.keymap.set('n', '<C-f>', function()
        Snacks.picker.lines()
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>sg', function()
        Snacks.picker.grep_buffers()
      end, { desc = '[S]earch by [G]rep in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })

      -- Snacks-only extra: there's no Telescope equivalent to mirror here.
      -- <C-t> is otherwise unbound (aside from the built-in tag-jump-back
      -- noted in plugins/lsp.lua), so there's no collision.
      vim.keymap.set('n', '<C-t>', function()
        Snacks.picker.smart()
      end, { desc = 'Smart Find Files' })
    end

    -- Always-on utility keymaps, independent of the picker backend flag -
    -- neither collides with an existing plugin's keymap.
    vim.keymap.set('n', '<leader>gB', function() -- capital B: gitsigns already owns <leader>gb/<leader>gd
      Snacks.gitbrowse()
    end, { desc = 'git [B]rowse (open remote in browser)' })
    vim.keymap.set('n', '<leader>x', function() -- <leader>b/<leader>B are DAP breakpoint leaves (see plugins/dap.lua)
      Snacks.bufdelete()
    end, { desc = 'Delete Buffer' })
  end,
}
