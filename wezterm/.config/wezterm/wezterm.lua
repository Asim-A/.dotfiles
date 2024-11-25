-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = "Github Dark"
config.automatically_reload_config = true
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = false
config.enable_scroll_bar = true

config.scrollback_lines = 5000

config.font = wezterm.font("JetBrains Mono")
-- and finally, return the configuration to wezterm
return config
