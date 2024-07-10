local wezterm = require("wezterm")
local act = wezterm.action

local function get_font_size()
	if wezterm.target_triple == "aarch64-apple-darwin" then
		return 16.0
	elseif wezterm.target_triple == "x86_64-unknown-linux-gnu" then
		return 12.0
	end
end

local config = {

	-- General settings
	enable_tab_bar = false,
	-- debug_key_events = true,

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
	font_size = get_font_size(),

	-- Key mappings
	keys = {
		{
			key = "Enter",
			mods = "ALT",
			action = act.ToggleFullScreen,
		},
	},
}

return config
