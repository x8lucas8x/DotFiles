local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.disable_default_key_bindings = true
config.window_background_opacity = 0.8
config.scrollback_lines = 200000
config.use_fancy_tab_bar = true

config.font = wezterm.font("CaskaydiaCove Nerd Font Mono", { weight = "Bold", stretch = "Normal", style = "Normal" })
config.font_size = 14
config.color_scheme = "GruvboxDarkHard"
config.cursor_blink_rate = 0
config.default_cursor_style = "SteadyBar"

function make_copy_mouse_binding(streak, button, mods)
	return {
		event = { Up = { streak = streak, button = button } },
		mods = mods,
		action = wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor("ClipboardAndPrimarySelection"),
	}
end

config.mouse_bindings = {
	make_copy_mouse_binding(1, "Left", "NONE"),
	make_copy_mouse_binding(1, "Left", "SHIFT"),
	make_copy_mouse_binding(1, "Left", "ALT"),
	make_copy_mouse_binding(1, "Left", "SHIFT|ALT"),
	make_copy_mouse_binding(2, "Left", "NONE"),
	make_copy_mouse_binding(3, "Left", "NONE"),
}

return config
