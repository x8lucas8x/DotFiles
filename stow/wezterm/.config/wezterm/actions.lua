local wezterm = require("wezterm")
local act = wezterm.action

local module = {}

function module.make_copy_mouse_binding(streak, button, mods)
	return {
		event = { Up = { streak = streak, button = button } },
		mods = mods,
		action = wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor("ClipboardAndPrimarySelection"),
	}
end

module.copy_clear_or_interrupt_action = wezterm.action_callback(function(window, pane)
	local has_selection = window:get_selection_text_for_pane(pane) ~= ""
	if has_selection then
		window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)

		window:perform_action(act.ClearSelection, pane)
	else
		window:perform_action(act.SendKey({ key = "c", mods = "CTRL" }), pane)
	end
end)

module.activate_panel_towards_left_action = wezterm.action_callback(function(window, pane)
	local tab = window:mux_window():active_tab()

	if tab:get_pane_direction("Left") ~= nil then
		window:perform_action(wezterm.action.ActivatePaneDirection("Left"), pane)
	else
		window:perform_action(wezterm.action.ActivateTabRelative(-1), pane)
	end
end)

module.activate_panel_towards_right_action = wezterm.action_callback(function(window, pane)
	local tab = window:mux_window():active_tab()

	if tab:get_pane_direction("Right") ~= nil then
		window:perform_action(wezterm.action.ActivatePaneDirection("Right"), pane)
	else
		window:perform_action(wezterm.action.ActivateTabRelative(1), pane)
	end
end)

module.move_tab_towards_left_action = wezterm.action_callback(function(window, pane)
	local tab = window:mux_window():active_tab()
	local tabs = window:mux_window():tabs()
	if tab:tab_id() == tabs[#tabs]:tab_id() then
		window:perform_action(wezterm.action.MoveTab(#tabs), pane)
	else
		window:perform_action(wezterm.action.MoveTabRelative(-1), pane)
	end
end)

module.move_tab_towards_right_action = wezterm.action_callback(function(window, pane)
	local tab = window:mux_window():active_tab()
	local tabs = window:mux_window():tabs()
	if tab:tab_id() == tabs[#tabs]:tab_id() then
		window:perform_action(wezterm.action.MoveTab(0), pane)
	else
		window:perform_action(wezterm.action.MoveTabRelative(1), pane)
	end
end)

return module
