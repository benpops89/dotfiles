local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Do not show the tab bar
config.enable_tab_bar = false

-- Set the opacity of the window
config.window_background_opacity = 0.8

-- Define the color scheme to use
config.color_scheme = 'Catppuccin Macchiato'

-- Change shell to zsh
config.default_prog = { '/usr/bin/zsh' }

return config
