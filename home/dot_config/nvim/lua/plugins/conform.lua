return { -- Autoformat
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '♣',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    -- Format-on-save is intentionally disabled: formatting is manual-only via
    -- the '♣' keymap above (Ctrl+Shift+Enter in WezTerm). Saving itself is
    -- handled continuously by auto-save.nvim (see plugins/auto-save.lua), so
    -- there's no separate format_on_save/format_after_save hook here.
    formatters_by_ft = {
      lua = { 'stylua' },
    },
  },
}
