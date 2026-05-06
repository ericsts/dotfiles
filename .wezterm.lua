-- WezTerm Dev Config (Pro Setup)
local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- =====================
-- 💾 SESSION PERSISTENCE (resurrect)
-- Salva e restaura workspaces, tabs e panes automaticamente.
-- Na primeira execução o plugin é baixado do GitHub (~segundos).
-- =====================
local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")

-- Salva automaticamente a cada 5 minutos
local function auto_save()
  wezterm.time.call_after(300, function()
    resurrect.save_state(resurrect.workspace_state.get_workspace_state())
    auto_save()
  end)
end
auto_save()

-- Salva ao fechar o WezTerm (ex: antes de reiniciar o Fedora)
wezterm.on("gui-shutdown", function()
  resurrect.save_state(resurrect.workspace_state.get_workspace_state())
end)

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
-- 🎨 TEMAS POR WORKSPACE
-- Defina aqui um background para cada workspace pelo nome.
-- Workspaces sem entrada usam o background padrão (#011423).
-- =====================
local workspace_themes = {
  -- ["nome-do-workspace"] = { bg = "#cor", opacity = 0.8 },
  ["default"]  = { bg = "#011423", opacity = 0.8 },
}

local function get_workspace_theme(name)
  return workspace_themes[name] or workspace_themes["default"]
end

wezterm.on("update-status", function(window, pane)
  -- Background dinâmico por workspace
  local theme = get_workspace_theme(window:active_workspace())
  window:set_config_overrides({
    colors                   = { background = theme.bg },
    window_background_opacity = theme.opacity,
  })

  -- Nome do workspace na status bar esquerda
  local workspace = window:active_workspace()
  window:set_left_status(wezterm.format({
    { Background = { Color = "#A277FF" } },
    { Foreground = { Color = "#011423" } },
    { Attribute  = { Intensity = "Bold" } },
    { Text = "  " .. workspace .. "  " },
    { Background = { Color = "#011423" } },
    { Foreground = { Color = "#A277FF" } },
    { Text = "" },
  }))
end)

-- =====================
-- 🪟 WINDOW
-- =====================
config.window_decorations = "NONE"
config.window_background_opacity = 0.8
config.window_background_gradient = { colors = { "#011423" } }

-- Tab bar mínima — mostra workspace e tabs, sem fancy decorations
config.enable_tab_bar    = true
config.use_fancy_tab_bar = false

config.colors.tab_bar = {
  background   = "#011423",
  active_tab   = { bg_color = "#033259", fg_color = "#CBE0F0", intensity = "Bold" },
  inactive_tab = { bg_color = "#011423", fg_color = "#214969" },
  inactive_tab_hover = { bg_color = "#0a2744", fg_color = "#CBE0F0" },
  new_tab      = { bg_color = "#011423", fg_color = "#214969" },
  new_tab_hover = { bg_color = "#0a2744", fg_color = "#47FF9C" },
}

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

  -- Tab navigator: popup com lista de todas as tabs para escolher
  { key = "w", mods = "LEADER", action = wezterm.action.ShowTabNavigator },

  -- Renomear tab atual
  {
    key = ",",
    mods = "LEADER",
    action = wezterm.action.PromptInputLine {
      description = "Renomear tab:",
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },

  -- Command Palette: busca e executa qualquer ação do WezTerm
  { key = "P", mods = "LEADER|SHIFT", action = wezterm.action.ActivateCommandPalette },

  -- Quick Select: destaca URLs, hashes, caminhos na tela para copiar com uma tecla
  { key = "s", mods = "LEADER", action = wezterm.action.QuickSelect },

  -- Workspaces: listar e trocar de workspace (sessões independentes)
  {
    key = "W",
    mods = "LEADER|SHIFT",
    action = wezterm.action.ShowLauncherArgs { flags = "WORKSPACES" },
  },

  -- Renomear workspace atual
  {
    key = "E",
    mods = "LEADER|SHIFT",
    action = wezterm.action.PromptInputLine {
      description = "Renomear workspace:",
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
        end
      end),
    },
  },

  -- Criar/trocar para workspace pelo nome
  {
    key = "$",
    mods = "LEADER|SHIFT",
    action = wezterm.action.PromptInputLine {
      description = "Nome do workspace (novo ou existente):",
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:perform_action(
            wezterm.action.SwitchToWorkspace { name = line },
            pane
          )
        end
      end),
    },
  },

  -- Sessão: salvar manualmente o workspace atual
  {
    key = "S",
    mods = "LEADER|SHIFT",
    action = wezterm.action_callback(function(win, pane)
      resurrect.save_state(resurrect.workspace_state.get_workspace_state())
      wezterm.log_info("Sessão salva: " .. wezterm.mux.get_active_workspace())
    end),
  },

  -- Sessão: restaurar workspace salvo (abre picker com sessões disponíveis)
  {
    key = "R",
    mods = "LEADER|SHIFT",
    action = wezterm.action_callback(function(win, pane)
      resurrect.fuzzy_load(win, pane, function(id)
        local state = resurrect.load_state(id)
        resurrect.workspace_state.restore_workspace(state, {
          window = win,
          relative_cwd = wezterm.home_dir,
        })
      end)
    end),
  },
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
config.scrollback_lines  = 10000
config.enable_scroll_bar = false

return config
