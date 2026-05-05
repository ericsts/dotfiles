-- WezTerm Dev Config (Pro Setup)
local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- =====================
-- 🎨 COLORS
-- =====================
config.colors = {
  foreground = "#CBE0F0",
  background = "#011423",
  cursor_bg = "#47FF9C",
  cursor_border = "#47FF9C",
  cursor_fg = "#011423",
  selection_bg = "#033259",
  selection_fg = "#CBE0F0",
  ansi = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#A277FF", "#24EAF7", "#24EAF7" },
  brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", "#A277FF", "#24EAF7", "#24EAF7" },
}

-- =====================
-- 🔤 FONT
-- =====================
config.font = wezterm.font("Hack Nerd Font Mono")
config.font_size = 16
config.line_height = 1.1

-- =====================
-- 🧠 PERFORMANCE
-- =====================
config.max_fps = 144
config.animation_fps = 60
config.front_end = "WebGpu"

-- =====================
-- 🪟 WINDOW
-- =====================
-- config.window_decorations = "RESIZE"
config.window_decorations = "NONE"
config.window_background_opacity = 0.8
config.enable_tab_bar = false
config.window_background_gradient = {
  colors = { "#011423" },
}
-- config.hide_tab_bar_if_only_one_tab = true

-- =====================
-- ⌨️ KEYBINDINGS (tmux-style)
-- =====================
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
  -- Split panes
  {
    key = "|",
    mods = "LEADER|SHIFT",
    action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" },
  },
  {
    key = "-",
    mods = "LEADER",
    action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" },
  },

  -- Navigate panes
  { key = "h", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Left") },
  { key = "j", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Down") },
  { key = "k", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Up") },
  { key = "l", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Right") },

  -- Resize panes
  { key = "H", mods = "LEADER|SHIFT", action = wezterm.action.AdjustPaneSize { "Left", 5 } },
  { key = "J", mods = "LEADER|SHIFT", action = wezterm.action.AdjustPaneSize { "Down", 5 } },
  { key = "K", mods = "LEADER|SHIFT", action = wezterm.action.AdjustPaneSize { "Up", 5 } },
  { key = "L", mods = "LEADER|SHIFT", action = wezterm.action.AdjustPaneSize { "Right", 5 } },

  -- Tabs
  { key = "c", mods = "LEADER", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
  { key = "n", mods = "LEADER", action = wezterm.action.ActivateTabRelative(1) },
  { key = "p", mods = "LEADER", action = wezterm.action.ActivateTabRelative(-1) },

  -- Close pane
  { key = "x", mods = "LEADER", action = wezterm.action.CloseCurrentPane { confirm = true } },

  -- Toggle zoom
  { key = "z", mods = "LEADER", action = wezterm.action.TogglePaneZoomState },
}

-- =====================
-- 🧩 MOUSE
-- =====================
config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "CTRL",
    action = wezterm.action.OpenLinkAtMouseCursor,
  },
}

-- =====================
-- 🚀 QUALITY OF LIFE
-- =====================
config.scrollback_lines = 10000
config.enable_scroll_bar = false
config.use_fancy_tab_bar = false

-- Copy mode like tmux/vim
config.keys = config.keys or {}

return config
