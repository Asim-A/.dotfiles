return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
  config = function()
    local harpoon = require 'harpoon'

    -- REQUIRED: Setup harpoon
    harpoon:setup {}

    -- REQUIRED: Essential Keymaps
    -- Add current file to Harpoon
    vim.keymap.set('n', '<leader>a', function()
      harpoon:list():add()
    end, { desc = 'Harpoon: Mark File' })

    -- Toggle the Harpoon Quick Menu
    vim.keymap.set('n', '<C-e>', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = 'Harpoon: Menu' })

    -- Fast Switching (The core of the workflow)
    -- Map to Ctrl + h, j, k, l for the first 4 marks
    vim.keymap.set('n', '<M-h>', function()
      harpoon:list():select(1)
    end)
    vim.keymap.set('n', '<M-j>', function()
      harpoon:list():select(2)
    end)
    vim.keymap.set('n', '<M-k>', function()
      harpoon:list():select(3)
    end)
    vim.keymap.set('n', '<M-l>', function()
      harpoon:list():select(4)
    end)

    local function clear_harpoon_list()
      harpoon:list():clear()
    end

    -- Example keymap
    vim.keymap.set('n', '<leader>h', function()
      clear_harpoon_list()
    end, { desc = 'Clear Harpoon list' })
    -- Picker UI integration - shows Harpoon marks in whichever picker
    -- backend (Telescope or snacks) is currently active. See
    -- lua/config/picker.lua for the wrapper implementation.
    --
    -- NOTE: <leader>sh is [S]earch [H]elp (see plugins/telescope.lua and
    -- plugins/snacks.lua); Harpoon marks live at <leader>sm instead to avoid
    -- silently shadowing it.
    vim.keymap.set('n', '<leader>sm', function()
      require('config.picker').harpoon_marks(harpoon:list())
    end, { desc = '[S]earch Harpoon [M]arks' })
  end,
}
