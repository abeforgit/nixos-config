local wezterm = require 'wezterm';
local config = wezterm.config_builder()

config.front_end = "WebGpu"
config.adjust_window_size_when_changing_font_size = false
config.audible_bell = "Disabled"
config.leader = { key = 'w', mods = 'ALT', timeout_milliseconds = 5000 }
config.font_size = 12
config.dpi = 192
config.font = wezterm.font { family = 'Lilex Nerd Font', harfbuzz_features = { "ss02=1" } }
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
  { key = 'j', mods = "CTRL|ALT",   action = wezterm.action.AdjustPaneSize { 'Down', 2 } },
  { key = 'k', mods = "CTRL|ALT",   action = wezterm.action.AdjustPaneSize { 'Up', 2 } },
  { key = 'h', mods = "CTRL|ALT",   action = wezterm.action.AdjustPaneSize { 'Left', 2 } },
  { key = 'l', mods = "CTRL|ALT",   action = wezterm.action.AdjustPaneSize { 'Right', 2 } },
  { key = 'j', mods = "ALT",        action = wezterm.action.ActivatePaneDirection 'Down' },
  { key = 'k', mods = "ALT",        action = wezterm.action.ActivatePaneDirection 'Up' },
  { key = 'h', mods = "ALT",        action = wezterm.action.ActivatePaneDirection 'Left' },
  { key = 'l', mods = "ALT",        action = wezterm.action.ActivatePaneDirection 'Right' },
  { key = 'r', mods = "ALT",        action = wezterm.action.RotatePanes 'Clockwise' },
  { key = 'g', mods = "ALT",        action = wezterm.action.PaneSelect { mode = 'SwapWithActive' } },
  { key = 'o', mods = "ALT",        action = wezterm.action.TogglePaneZoomState },
  { key = 'l', mods = "CTRL|SHIFT", action = wezterm.action.DisableDefaultAssignment },
  { key = 'k', mods = "CTRL|SHIFT", action = wezterm.action.DisableDefaultAssignment }
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
