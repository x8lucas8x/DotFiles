local wezterm = require("wezterm")
local actions = require("actions")
local smart_splits = require("smart_splits")
local act = wezterm.action

local config = wezterm.config_builder()
local devbox_host = os.getenv("DEVBOX_HOST") or ""
local is_tilling_window_environment = os.getenv("IS_TILLING_WINDOW_ENVIRONMENT") == "1"

config.disable_default_key_bindings = true
config.window_background_opacity = 0.8
config.scrollback_lines = 200000
config.use_fancy_tab_bar = true
-- Necessary as I use a german keyboard, for tildes mostly.
config.use_dead_keys = true
config.font = wezterm.font("CaskaydiaCove Nerd Font Mono", { weight = "Bold", stretch = "Normal", style = "Normal" })
config.font_size = 14
config.color_scheme = "GruvboxDarkHard"
config.cursor_blink_rate = 0
config.default_cursor_style = "SteadyBar"
config.enable_scroll_bar = true
config.pane_focus_follows_mouse = true
config.inactive_pane_hsb = {
	saturation = 0.6,
	brightness = 0.6,
}
config.unzoom_on_switch_pane = true
config.automatically_reload_config = true

if devbox_host then
	config.ssh_domains = {
		{
			name = "devbox",
			remote_address = devbox_host,
			local_echo_threshold_ms = 10,
		},
	}
end

config.mouse_bindings = {
	actions.make_copy_mouse_binding(1, "Left", "NONE"),
	actions.make_copy_mouse_binding(1, "Left", "SHIFT"),
	actions.make_copy_mouse_binding(1, "Left", "ALT"),
	actions.make_copy_mouse_binding(1, "Left", "SHIFT|ALT"),
	actions.make_copy_mouse_binding(2, "Left", "NONE"),
	actions.make_copy_mouse_binding(3, "Left", "NONE"),
	{
		event = { Down = { streak = 3, button = "Left" } },
		action = wezterm.action.SelectTextAtMouseCursor("SemanticZone"),
		mods = "NONE",
	},
}

-- Timeout_milliseconds defaults to 1000 and can be omitted
config.leader = { key = "W", mods = "CTRL|SHIFT|SUPER", timeout_milliseconds = 2000 }

config.keys = {
	-- Key tables
	{
		key = "s",
		mods = "LEADER",
		action = act.ActivateKeyTable({
			name = "search_mode",
			one_shot = true,
			until_unknown = true,
		}),
	},
	{
		key = "r",
		mods = "LEADER",
		action = act.ActivateKeyTable({
			name = "resize_pane_mode",
			one_shot = false,
			until_unknown = true,
		}),
	},
	{
		key = "p",
		mods = "LEADER",
		action = act.ActivateKeyTable({
			name = "pane_mode",
			one_shot = false,
			until_unknown = true,
		}),
	},
	{
		key = "t",
		mods = "LEADER",
		action = act.ActivateKeyTable({
			name = "tab_mode",
			one_shot = false,
			until_unknown = true,
		}),
	},
	-- Copy/Paste
	{ key = "c", mods = "CTRL", action = actions.copy_clear_or_interrupt_action },
	{ key = "c", mods = "SUPER", action = actions.copy_clear_or_interrupt_action },
	{ key = "v", mods = "CTRL", action = act.PasteFrom("Clipboard") },
	{ key = "v", mods = "SUPER", action = act.PasteFrom("Clipboard") },
	-- Tabs
	{ key = "LeftArrow", mods = "SHIFT", action = actions.activate_panel_towards_left_action },
	{ key = "RightArrow", mods = "SHIFT", action = actions.activate_panel_towards_right_action },
	-- Normal scroll
	{ key = "PageUp", mods = "SHIFT", action = act.ScrollByPage(-0.5) },
	{ key = "PageDown", mods = "SHIFT", action = act.ScrollByPage(0.5) },
	{ key = "Home", mods = "SHIFT", action = act.ScrollToTop },
	{ key = "End", mods = "SHIFT", action = act.ScrollToBottom },
	-- Semantic scroll
	{ key = "UpArrow", mods = "SHIFT", action = act.ScrollToPrompt(-1) },
	{ key = "DownArrow", mods = "SHIFT", action = act.ScrollToPrompt(1) },
	-- Set font size
	{ key = "+", mods = "CTRL", action = wezterm.action.IncreaseFontSize },
	{ key = "+", mods = "SUPER", action = wezterm.action.IncreaseFontSize },
	{ key = "-", mods = "CTRL", action = wezterm.action.DecreaseFontSize },
	{ key = "-", mods = "SUPER", action = wezterm.action.DecreaseFontSize },
	{ key = "0", mods = "CTRL", action = wezterm.action.ResetFontSize },
	{ key = "0", mods = "SUPER", action = wezterm.action.ResetFontSize },
	-- Toggles pane zoom
	{ key = "f", mods = "CTRL", action = wezterm.action.TogglePaneZoomState },
	-- Activates the debug overlay
	{ key = "L", mods = "CTRL", action = wezterm.action.ShowDebugOverlay },
	-- Move between split panes
	smart_splits.make_split_nav_binding("move", "h"),
	smart_splits.make_split_nav_binding("move", "j"),
	smart_splits.make_split_nav_binding("move", "k"),
	smart_splits.make_split_nav_binding("move", "l"),
	-- Resize panes
	smart_splits.make_split_nav_binding("resize", "h"),
	smart_splits.make_split_nav_binding("resize", "j"),
	smart_splits.make_split_nav_binding("resize", "k"),
	smart_splits.make_split_nav_binding("resize", "l"),
}

config.key_tables = {
	-- Defines the keys that are active in our search mode.
	search_mode = {
		{ key = "s", action = act.Search({ Regex = "" }) },

		{ key = "UpArrow", mods = "NONE", action = act.CopyMode("PriorMatch") },
		{ key = "k", mods = "NONE", action = act.CopyMode("PriorMatch") },

		{ key = "DownArrow", mods = "NONE", action = act.CopyMode("NextMatch") },
		{ key = "j", mods = "NONE", action = act.CopyMode("NextMatch") },

		-- Cancel the mode by pressing escape
		{ key = "Escape", action = "PopKeyTable" },
	},

	-- Defines the keys that are active in our resize-pane mode.
	-- Since we're likely to want to make multiple adjustments,
	-- we made the activation one_shot=false. We therefore need
	-- to define a key assignment for getting out of this mode.
	-- 'resize_pane_mode' here corresponds to the name="resize_pane_mode" in
	-- the key assignments above.
	resize_pane_mode = {
		{ key = "LeftArrow", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },

		{ key = "RightArrow", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },

		{ key = "UpArrow", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },

		{ key = "DownArrow", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },

		-- Cancel the mode by pressing escape
		{ key = "Escape", action = "PopKeyTable" },
	},

	-- Defines the keys that are active in our pane mode.
	-- 'pane_mode' here corresponds to the name="pane_mode" in
	-- the key assignments above.
	pane_mode = {
		{ key = "x", action = wezterm.action.CloseCurrentPane({ confirm = false }) },

		{ key = "LeftArrow", action = act.ActivatePaneDirection("Left") },
		{ key = "h", action = act.ActivatePaneDirection("Left") },

		{ key = "RightArrow", action = act.ActivatePaneDirection("Right") },
		{ key = "l", action = act.ActivatePaneDirection("Right") },

		{ key = "UpArrow", action = act.ActivatePaneDirection("Up") },
		{ key = "k", action = act.ActivatePaneDirection("Up") },

		{ key = "DownArrow", action = act.ActivatePaneDirection("Down") },
		{ key = "j", action = act.ActivatePaneDirection("Down") },

		-- Rotate panes
		{
			key = "Space",
			action = wezterm.action.RotatePanes("Clockwise"),
		},
		-- Show the pane selection mode, but have it swap the active and selected panes
		{
			key = "0",
			action = wezterm.action.PaneSelect({
				mode = "SwapWithActive",
			}),
		},
		-- Vertical split
		{
			key = "|",
			action = act.SplitPane({
				direction = "Right",
				size = { Percent = 50 },
			}),
		},
		-- Horizontal split
		{
			key = "-",
			action = act.SplitPane({
				direction = "Down",
				size = { Percent = 50 },
			}),
		},

		-- Cancel the mode by pressing escape
		{ key = "Escape", action = "PopKeyTable" },
	},

	-- Defines the keys that are active in our tab mode.
	-- 'tab_mode' here corresponds to the name="tab_mode" in
	-- the key assignments above.
	tab_mode = {
		{ key = "n", action = act.SpawnTab("CurrentPaneDomain") },
		{ key = "x", action = wezterm.action.CloseCurrentTab({ confirm = false }) },

		{ key = "LeftArrow", action = act.ActivateTabRelative(-1) },
		{ key = "h", action = act.ActivateTabRelative(-1) },

		{ key = "RightArrow", action = act.ActivateTabRelative(1) },
		{ key = "l", action = act.ActivateTabRelative(1) },

		{ key = "1", action = act.ActivateTab(0) },
		{ key = "2", action = act.ActivateTab(1) },
		{ key = "3", action = act.ActivateTab(2) },
		{ key = "4", action = act.ActivateTab(3) },
		{ key = "5", action = act.ActivateTab(4) },
		{ key = "6", action = act.ActivateTab(5) },

		-- Rotate tabs
		{
			key = "Space",
			action = actions.move_tab_towards_right_action,
		},

		-- Cancel the mode by pressing escape
		{ key = "Escape", action = "PopKeyTable" },
	},
}

wezterm.on("update-status", function(window, pane)
	local SOLID_LEFT_ARROW = ""
	local ARROW_FOREGROUND = { Foreground = { Color = "#c6a0f6" } } -- color:mauve
	local default_status = is_tilling_window_environment and "" or (config.leader.mods .. " + " .. config.leader.key)
	local active_key_table = window:active_key_table()
	local leader_is_active = window:leader_is_active()
	local config_overrides = window:get_config_overrides() or {}

	local suffix = ""
	local prefix = ""

	if window:active_tab():tab_id() ~= 0 then
		ARROW_FOREGROUND = { Foreground = { Color = "#f9f5d7" } } -- color:mantle
	end -- Arrow color based on if tab is first pane

	if leader_is_active then
		suffix = " " .. utf8.char(0x1f30a) -- ocean wave utf8 character
		SOLID_LEFT_ARROW = utf8.char(0xe0b2)

		for k, _ in pairs(config.key_tables) do
			prefix = (prefix ~= "") and (prefix .. " " .. k) or k
		end

		prefix = "TABLES: " .. prefix
	elseif active_key_table then
		for _, v in pairs(config.key_tables[active_key_table]) do
			prefix = (prefix ~= "") and (prefix .. " " .. v.key) or v.key
		end

		prefix = "TABLE: " .. active_key_table .. " > " .. prefix
	else
		prefix = default_status
	end

	window:set_left_status(wezterm.format({
		{ Text = suffix },
		ARROW_FOREGROUND,
		{ Text = SOLID_LEFT_ARROW },
	}))
	window:set_right_status(prefix)

	local our_tab = pane:tab()
	local is_zoomed = false
	if our_tab ~= nil then
		for _, pane_attributes in pairs(our_tab:panes_with_info()) do
			is_zoomed = pane_attributes["is_zoomed"] or is_zoomed
		end
	end

	if is_zoomed then
		window:set_right_status(prefix .. " [ZOOMED]")
		config_overrides.window_frame = {
			border_left_width = "0.5cell",
			border_right_width = "0.5cell",
			border_top_height = "0.5cell",
			border_left_color = "purple",
			border_right_color = "purple",
			border_top_color = "purple",
		}
	else
		config_overrides.window_frame = {}
		config_overrides.window_padding = {}
	end

	window:set_config_overrides(config_overrides)
end)

wezterm.on("format-tab-title", function(tab, _, panes, _, _, _)
	local title = (tab.tab_index + 1) .. ": " .. tab.active_pane.title

	local our_tab = tab
	local is_zoomed = false
	if our_tab ~= nil then
		for _, pane_attributes in pairs(panes) do
			is_zoomed = pane_attributes["is_zoomed"] or is_zoomed
		end
	end

	if tab.is_active and is_zoomed then
		return {
			{ Background = { Color = "purple" } },
			{ Text = title .. " [ZOOMED]" },
		}
	end

	return title
end)

wezterm.on("window-config-reloaded", function(window, _)
	window:toast_notification("wezterm", "Configuration reloaded!", nil, 4000)
end)

wezterm.on("gui-startup", function(cmd)
	-- allow `wezterm start -- something` to affect what we spawn
	-- in our initial window
	local args = {}
	if cmd then
		args = cmd.args
	end

	local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

config.unix_domains = {
	{
		name = "unix",
	},
}

-- This causes `wezterm` to act as though it was started as
-- `wezterm connect unix` by default, connecting to the unix
-- domain on startup.
-- If you prefer to connect manually, leave out this line.
-- config.default_gui_startup_args = { 'connect', 'unix' }

return config
