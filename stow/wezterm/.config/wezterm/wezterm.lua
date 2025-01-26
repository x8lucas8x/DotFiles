local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.disable_default_key_bindings = true
config.window_background_opacity = 0.8
config.window_decorations = "RESIZE"
config.scrollback_lines = 200000
config.window_frame = {
	font = wezterm.font({ family = "CaskaydiaCove Nerd Font Mono", weight = "Bold" }),
	font_size = 14,
}
config.color_scheme = "GruvboxDarkHard"
config.cursor_blink_rate = 0
config.default_cursor_style = "SteadyBar"

return config
