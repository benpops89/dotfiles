local wezterm = require("wezterm")
local config = {

	-- General settings
	enable_tab_bar = false,

	-- MacOS specific settings
	native_macos_fullscreen_mode = false,
	macos_window_background_blur = 20,

	-- Window settings
	window_background_opacity = 0.8,
	window_decorations = "RESIZE",
	adjust_window_size_when_changing_font_size = false,

	-- Colour scheme
	color_scheme = "Catppuccin Macchiato",

	-- Fonts
	font_size = 14.0,

	-- Key mappings
	keys = {
		{
			key = "Enter",
			mods = "ALT",
			action = wezterm.action.ToggleFullScreen,
		},
	},
}

return config
