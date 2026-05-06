-- WezTerm Dev Config (Pro Setup)
local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- =====================
-- 💾 SESSION PERSISTENCE (resurrect)
-- Salva e restaura workspaces, tabs e panes automaticamente.
-- Na primeira execução o plugin é baixado do GitHub (~segundos).
-- =====================
local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")

-- Salva o estado de TODOS os workspaces abertos
local function save_all_workspaces()
  for _, workspace in ipairs(wezterm.mux.get_workspace_names()) do
    local state = resurrect.workspace_state.get_workspace_state(workspace)
    if state then
      resurrect.save_state(state)
    end
  end
end

-- Salva automaticamente a cada 5 minutos
local function auto_save()
  wezterm.time.call_after(300, function()
    save_all_workspaces()
    auto_save()
  end)
end
auto_save()

-- Salva todos os workspaces ao fechar o WezTerm
wezterm.on("gui-shutdown", function()
  save_all_workspaces()
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
  -- bg     = cor de fundo da janela
  -- opacity = transparência da janela
  -- accent  = cor do badge do workspace name na tab bar
  ["default"] = { bg = "#011423", opacity = 0.8, accent = "#A277FF" },
  ["ERIC"]    = { bg = "#00FF7F", opacity = 0.8, accent = "#00cc66" },
  ["PMT"]     = { bg = "#1E90FF", opacity = 0.8, accent = "#1E90FF" },
}

-- Gera um hue (0-359) consistente a partir do nome do workspace
local function name_to_hue(name)
  local hash = 0
  for i = 1, #name do
    hash = (hash * 31 + string.byte(name, i)) % 360
  end
  return hash
end

-- Converte HSL para hex RGB
local function hsl_to_hex(h, s, l)
  s, l = s / 100, l / 100
  local c = (1 - math.abs(2 * l - 1)) * s
  local x = c * (1 - math.abs((h / 60) % 2 - 1))
  local m = l - c / 2
  local r, g, b = 0, 0, 0
  if     h < 60  then r, g, b = c, x, 0
  elseif h < 120 then r, g, b = x, c, 0
  elseif h < 180 then r, g, b = 0, c, x
  elseif h < 240 then r, g, b = 0, x, c
  elseif h < 300 then r, g, b = x, 0, c
  else                r, g, b = c, 0, x end
  return string.format("#%02X%02X%02X",
    math.floor((r + m) * 255 + 0.5),
    math.floor((g + m) * 255 + 0.5),
    math.floor((b + m) * 255 + 0.5))
end

-- Para workspaces não configurados: gera accent e bg a partir do nome
local function get_workspace_theme(name)
  if workspace_themes[name] then
    return workspace_themes[name]
  end
  local hue    = name_to_hue(name)
  local accent = hsl_to_hex(hue, 70, 65)  -- cor vibrante para o badge
  local bg     = hsl_to_hex(hue, 40, 8)   -- escuro com leve toque da cor
  return { bg = bg, opacity = 0.8, accent = accent }
end

wezterm.on("update-status", function(window, pane)
  local workspace = window:active_workspace()
  local theme     = get_workspace_theme(workspace)

  -- Background e opacidade dinâmicos por workspace
  window:set_config_overrides({
    colors                    = { background = theme.bg },
    window_background_opacity = theme.opacity,
  })

  -- Badge do workspace com cor de acento própria
  window:set_left_status(wezterm.format({
    { Background = { Color = theme.accent } },
    { Foreground = { Color = "#011423" } },
    { Attribute  = { Intensity = "Bold" } },
    { Text = "  " .. workspace .. "  " },
    { Background = { Color = "#011423" } },
    { Foreground = { Color = theme.accent } },
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

  -- Workspaces: próximo / anterior
  { key = "]", mods = "LEADER", action = wezterm.action.SwitchWorkspaceRelative(1)  },
  { key = "[", mods = "LEADER", action = wezterm.action.SwitchWorkspaceRelative(-1) },

  -- Panes: picker visual (mostra label em cada pane para pular direto)
  { key = "q", mods = "LEADER", action = wezterm.action.PaneSelect },

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
