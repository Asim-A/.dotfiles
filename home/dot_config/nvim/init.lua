-- Personal Neovim config -- see README.md for an overview of the layout.
--
-- This file only bootstraps: general settings/keymaps/autocmds live under
-- lua/config/, and every plugin spec lives under lua/plugins/ (one file per
-- plugin/feature, auto-imported by lua/config/lazy.lua).
require 'config.options'
require 'config.keymaps'
require 'config.autocmds'
require 'config.lazy'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
