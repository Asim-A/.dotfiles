-- autopairs
-- https://github.com/windwp/nvim-autopairs

return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  -- Auto-inserting `(` after accepting a function/method completion is
  -- handled natively by blink.cmp (see completion.accept.auto_brackets in
  -- plugins/completion.lua), so nvim-autopairs no longer needs a
  -- completion-engine dependency here.
  config = function()
    require('nvim-autopairs').setup {}
  end,
}
