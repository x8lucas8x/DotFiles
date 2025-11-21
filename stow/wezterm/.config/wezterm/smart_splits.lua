local wezterm = require("wezterm")

local module = {}

-- if you are *NOT* lazy-loading smart-splits.nvim (recommended)
local function is_vim(pane)
  -- This gsub is equivalent to POSIX basename(3)
  -- Given "/foo/bar" returns "bar"
  -- Given "c:\\foo\\bar" returns "bar"
  local process_name = string.gsub(pane:get_foreground_process_name(), '(.*[/\\])(.*)', '%2')
  return process_name == 'nvim' or process_name == 'vim'
end

local function is_zellij(pane)
	local process_name = string.gsub(pane:get_foreground_process_name(), "(.*[/\\])(.*)", "%2")
	return process_name == "zellij"
end

local direction_keys = {
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}

function module.make_split_nav_binding(resize_or_move, key)
	return {
		key = key,
		mods = resize_or_move == "resize" and "META" or "CTRL",
		action = wezterm.action_callback(function(win, pane)
			local has_single_pane = #win:active_tab():panes() == 1
			if is_vim(pane) then
				-- Pass the keys through to vim/nvim
				win:perform_action({
					SendKey = { key = key, mods = resize_or_move == "resize" and "META" or "CTRL" },
				}, pane)
			elseif is_zellij(pane) and has_single_pane then
				-- Pass the keys through to zellij
				if resize_or_move == "resize" then
					win:perform_action({
						SendKey = { key = "n", mods = "CTRL" },
					}, pane)
					win:perform_action({
						SendKey = { key = key },
					}, pane)
				else
					win:perform_action({
						SendKey = { key = key, mods = "ALT" },
					}, pane)
				end
			else
				if resize_or_move == "resize" then
					win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
				else
					win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
				end
			end
		end),
	}
end

return module
