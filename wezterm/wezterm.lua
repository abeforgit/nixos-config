local wezterm = require 'wezterm';


-- if you are *NOT* lazy-loading smart-splits.nvim (recommended)
local function is_vim(pane)
  -- this is set by the plugin, and unset on ExitPre in Neovim
  return pane:get_user_vars().IS_NVIM == 'true'
end

-- if you *ARE* lazy-loading smart-splits.nvim (not recommended)
-- you have to use this instead, but note that this will not work
-- in all cases (e.g. over an SSH connection). Also note that
-- `pane:get_foreground_process_name()` can have high and highly variable
-- latency, so the other implementation of `is_vim()` will be more
-- performant as well.
local function is_vim(pane)
  -- This gsub is equivalent to POSIX basename(3)
  -- Given "/foo/bar" returns "bar"
  -- Given "c:\\foo\\bar" returns "bar"
  local process_name = string.gsub(pane:get_foreground_process_name(), '(.*[/\\])(.*)', '%2')
  return process_name == 'nvim' or process_name == 'vim'
end

local direction_keys = {
  h = 'Left',
  j = 'Down',
  k = 'Up',
  l = 'Right',
}

local function split_nav(resize_or_move, key)
  return {
    key = key,
    mods = resize_or_move == 'resize' and 'META' or 'CTRL',
    action = w.action_callback(function(win, pane)
      if is_vim(pane) then
        -- pass the keys through to vim/nvim
        win:perform_action({
          SendKey = { key = key, mods = resize_or_move == 'resize' and 'META' or 'CTRL' },
        }, pane)
      else
        if resize_or_move == 'resize' then
          win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
        else
          win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
        end
      end
    end),
  }
end




local config = wezterm.config_builder()


config.front_end = "WebGpu"
config.adjust_window_size_when_changing_font_size = false
config.audible_bell = "Disabled"
config.leader = { key = 'w', mods = 'ALT', timeout_milliseconds = 5000 }
config.font_size = 12
-- config.dpi = 192
config.font = wezterm.font { family = 'Atkinson Hyperlegible Mono', harfbuzz_features = { "ss02=1" } }
config.enable_kitty_keyboard = true
local act = wezterm.action
config.mouse_bindings = {
  {
    event = { Down = { streak = 1, button = { WheelUp = 1 } } },
    mods = 'NONE',
    alt_screem = false,
    action = act.ScrollByLine(-3),
  },
  {
    event = { Down = { streak = 1, button = { WheelDown = 1 } } },
    mods = 'NONE',
    alt_screem = false,
    action = act.ScrollByLine(3),
  },
}
config.hide_mouse_cursor_when_typing = false
config.xcursor_size = 24
-- config.xcursor_theme = Nordzy_cursors
config.color_scheme = 'Arthur'
config.check_for_updates = false
config.keys = {
  {
    key = 'v',
    mods = "CTRL|SHIFT",
    action = wezterm.action.EmitEvent("wsl-paste-workaround")
  },
  { key = 'v', mods = "ALT",        action = wezterm.action.SplitHorizontal },
  { key = 's', mods = "ALT",        action = wezterm.action.SplitVertical },
  { key = 'd', mods = "ALT",        action = wezterm.action.CloseCurrentPane { confirm = false } },
  { key = 'w', mods = "ALT|CTRL",   action = wezterm.action.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' } },
  { key = 'c', mods = "ALT",        action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
  { key = 'n', mods = "ALT",        action = wezterm.action.ActivateTabRelative(1) },
  { key = 'p', mods = "ALT",        action = wezterm.action.ActivateTabRelative(-1) },
  -- { key = 'j', mods = "CTRL|ALT",   action = wezterm.action.AdjustPaneSize { 'Down', 2 } },
  -- { key = 'k', mods = "CTRL|ALT",   action = wezterm.action.AdjustPaneSize { 'Up', 2 } },
  -- { key = 'h', mods = "CTRL|ALT",   action = wezterm.action.AdjustPaneSize { 'Left', 2 } },
  -- { key = 'l', mods = "CTRL|ALT",   action = wezterm.action.AdjustPaneSize { 'Right', 2 } },
  -- { key = 'j', mods = "ALT",        action = wezterm.action.ActivatePaneDirection 'Down' },
  -- { key = 'k', mods = "ALT",        action = wezterm.action.ActivatePaneDirection 'Up' },
  -- { key = 'h', mods = "ALT",        action = wezterm.action.ActivatePaneDirection 'Left' },
  -- { key = 'l', mods = "ALT",        action = wezterm.action.ActivatePaneDirection 'Right' },
  { key = 'r', mods = "ALT",        action = wezterm.action.RotatePanes 'Clockwise' },
  { key = 'g', mods = "ALT",        action = wezterm.action.PaneSelect { mode = 'SwapWithActive' } },
  { key = 'o', mods = "ALT",        action = wezterm.action.TogglePaneZoomState },
  { key = 'l', mods = "CTRL|SHIFT", action = wezterm.action.DisableDefaultAssignment },
  { key = 'k', mods = "CTRL|SHIFT", action = wezterm.action.DisableDefaultAssignment },

  split_nav('move', 'h'),
  split_nav('move', 'j'),
  split_nav('move', 'k'),
  split_nav('move', 'l'),
  -- resize panes
  split_nav('resize', 'h'),
  split_nav('resize', 'j'),
  split_nav('resize', 'k'),
  split_nav('resize', 'l'),



}
wezterm.on("wsl-paste-workaround", function(window, pane)
  local success, stdout, stderr = wezterm.run_child_process({ "wl-paste", "--no-newline" })
  if success then
    pane:paste(stdout)
  else
    wezterm.log_error("wl-paste failed with\n" .. stderr .. stdout)
  end
end)
return config
