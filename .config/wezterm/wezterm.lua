-- ██╗    ██╗███████╗███████╗████████╗███████╗██████╗ ███╗   ███╗
-- ██║    ██║██╔════╝╚══███╔╝╚══██╔══╝██╔════╝██╔══██╗████╗ ████║
-- ██║ █╗ ██║█████╗    ███╔╝    ██║   █████╗  ██████╔╝██╔████╔██║
-- ██║███╗██║██╔══╝   ███╔╝     ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║
-- ╚███╔███╔╝███████╗███████╗   ██║   ███████╗██║  ██║██║ ╚═╝ ██║
--  ╚══╝╚══╝ ╚══════╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝

-- https://github.com/wezterm/wezterm

local wezterm = require("wezterm")
local act = wezterm.action

-- 1. Use the modern config builder for better error messages/autocompletion
local config = wezterm.config_builder()

local function get_font_size()
	-- Using 'find' is safer in case the triple string varies slightly
	if wezterm.target_triple:find("apple") then
		return 18.0
	else
		return 14.0
	end
end

-- General settings
config.enable_tab_bar = false
-- config.debug_key_events = true

-- MacOS specific settings
config.native_macos_fullscreen_mode = false
config.macos_window_background_blur = 20
-- Crucial for your tmux bindings to work on Mac
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

-- Window settings
config.window_background_opacity = 0.7
config.window_decorations = "RESIZE"
config.adjust_window_size_when_changing_font_size = false

-- Colour scheme
config.color_scheme = "Catppuccin Macchiato"

-- Fonts
config.font_size = get_font_size()
config.font = wezterm.font("Maple Mono NF")
config.line_height = 1.1
config.window_padding = {
	left = 10,
	right = 10,
	top = 10,
	bottom = 10,
}

-- Key mappings
config.keys = {
	{
		key = "Enter",
		mods = "CTRL",
		action = act.ToggleFullScreen,
	},
	{
		key = "Enter",
		mods = "ALT",
		action = act.DisableDefaultAssignment,
	},
	-- Fix: Disable Alt+h/j/k/l defaults in WezTerm if they clash with tmux
	{ key = "h", mods = "ALT", action = act.DisableDefaultAssignment },
	{ key = "j", mods = "ALT", action = act.DisableDefaultAssignment },
	{ key = "k", mods = "ALT", action = act.DisableDefaultAssignment },
	{ key = "l", mods = "ALT", action = act.DisableDefaultAssignment },
}

return config
