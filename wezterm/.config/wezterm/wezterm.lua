-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
--
config.keys = {
	{ key = "h", mods = "CMD", action = wezterm.action.SendString("\x1bh") }, -- Alt+h
	{ key = "j", mods = "CMD", action = wezterm.action.SendString("\x1bj") }, -- Alt+j
	{ key = "k", mods = "CMD", action = wezterm.action.SendString("\x1bk") }, -- Alt+k
	{ key = "l", mods = "CMD", action = wezterm.action.SendString("\x1bl") }, -- Alt+l
	{ key = "n", mods = "CMD", action = wezterm.action.SendString("\x1bn") }, -- Alt+n
	{ key = "p", mods = "CMD", action = wezterm.action.SendString("\x1bp") }, -- Alt+p
	{ key = "f", mods = "CMD", action = wezterm.action.SendKey({ key = "f", mods = "CTRL" }) }, -- disable cmd+f

	-- ♔ ♕ ♖ ♗ ♘ ♙ ♚ ♛ ♜ ♝ ♞ 
	{ key = "F", mods = "CMD|SHIFT", action = wezterm.action.SendString("♠") },
	{ key = "Enter", mods = "CMD|SHIFT", action = wezterm.action.SendString("♣") },
}

-- For example, changing the color scheme:
config.color_scheme = "GruvboxDarkHard"

config.automatically_reload_config = true
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true

-- config.send_composed_key_when_left_alt_is_pressed = false
-- config.send_composed_key_when_right_alt_is_pressed = true

config.enable_scroll_bar = true

config.scrollback_lines = 5000
config.font = wezterm.font("JetBrains Mono")
-- and finally, return the configuration to wezterm
return config
