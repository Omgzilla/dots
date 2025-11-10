local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.enable_wayland = false
config.front_end = 'WebGpu'

config.initial_cols = 120
config.initial_rows = 28

config.bold_brightens_ansi_colors = true
config.hide_tab_bar_if_only_one_tab = true
config.pane_focus_follows_mouse = true
config.cursor_blink_rate = 800
config.text_blink_rate = 500

config.enable_scroll_bar = true
config.scrollback_lines = 100000
config.font = wezterm.font('Ubuntu Mono', { weight = 'Light', style = 'Normal'})
config.font_size = 10

config.color_scheme = 'Catppuccin Mocha'
config.colors = {
  scrollbar_thumb = 'rgba(86,95,137,90%)'
}
config.window_background_opacity = 0.95

local a = wezterm.action
config.keys = {
  { key = 'e', mods = 'CTRL|SHIFT', action = a.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'o', mods = 'CTRL|SHIFT', action = a.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'h', mods = 'CTRL|SHIFT', action = a.ActivatePaneDirection 'Left' },
  { key = 'l', mods = 'CTRL|SHIFT', action = a.ActivatePaneDirection 'Right' },
  { key = 'k', mods = 'CTRL|SHIFT', action = a.ActivatePaneDirection 'Up' },
  { key = 'j', mods = 'CTRL|SHIFT', action = a.ActivatePaneDirection 'Down' },
  { key = 'LeftArrow', mods = 'CTRL|SHIFT', action = a.AdjustPaneSize { 'Left', 5 } },
  { key = 'RightArrow', mods = 'CTRL|SHIFT', action = a.AdjustPaneSize { 'Right', 5 } },
  { key = 'UpArrow', mods = 'CTRL|SHIFT', action = a.AdjustPaneSize { 'Up', 5 } },
  { key = 'DownArrow', mods = 'CTRL|SHIFT', action = a.AdjustPaneSize { 'Down', 5 } },
  { key = 'n', mods = 'CTRL|SHIFT', action = a.RotatePanes 'Clockwise' },
  { key = 'p', mods = 'CTRL|SHIFT', action = a.RotatePanes 'CounterClockwise' },
  { key = 'x', mods = 'CTRL|SHIFT', action = a.TogglePaneZoomState },
}
-- config.mouse_bindings = {
--  { event = { Drag = { streak = 1, button = 'Left' } }, mods = 'CTRL|SHIFT', action = a.StartWindowDrag },
-- }

return config
