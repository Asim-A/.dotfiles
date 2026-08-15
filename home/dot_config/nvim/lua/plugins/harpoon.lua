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
    -- OPTIONAL: Telescope UI integration
    -- If you prefer searching through your marks with Telescope
    local conf = require('telescope.config').values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

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

    vim.keymap.set('n', '<leader>sh', function()
      toggle_telescope(harpoon:list())
    end, { desc = 'Search Harpoon Marks' })
  end,
}
