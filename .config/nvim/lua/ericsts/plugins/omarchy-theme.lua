-- nvim/lua/ericsts/plugins/omarchy-theme.lua
-- TEMA DO OMARCHY: usa o mesmo tema escolhido no Omarchy (Super+Ctrl+Shift+Space)
-- e troca de cores na hora quando o tema muda, sem reiniciar o Neovim.
--
-- O Omarchy gera ~/.local/state/omarchy/current/theme/neovim.lua no formato do
-- LazyVim: { <plugin do tema>, { "LazyVim/LazyVim", opts = { colorscheme = ... } } }.
-- Aqui lemos esse arquivo, ignoramos a parte do LazyVim e aplicamos o colorscheme.
-- Fora do Omarchy (arquivo ausente), cai no tokyonight.

local state_dir = vim.fn.expand("~/.local/state/omarchy/current")
local theme_file = state_dir .. "/theme/neovim.lua"
local fallback = "tokyonight"

-- Plugins de todos os temas do Omarchy (carregados sob demanda), para a troca
-- de tema funcionar na hora mesmo quando o tema novo usa outro plugin.
local themes = {
  { "bjarneo/aether.nvim", branch = "v3", name = "aether" },
  { "catppuccin/nvim", name = "catppuccin" },
  { "rose-pine/neovim", name = "rose-pine" },
  { "ribru17/bamboo.nvim" },
  { "bjarneo/ethereal.nvim" },
  { "bjarneo/hackerman.nvim" },
  { "bjarneo/vantablack.nvim" },
  { "bjarneo/white.nvim" },
  { "neanias/everforest-nvim" },
  { "kepano/flexoki-neovim" },
  { "ellisonleao/gruvbox.nvim" },
  { "rebelot/kanagawa.nvim" },
  { "tahayvr/matteblack.nvim" },
  { "gthelding/monokai-pro.nvim" },
  { "EdenEast/nightfox.nvim" },
  { "ficcdaf/ashen.nvim" },
  { "folke/tokyonight.nvim" },
  { "OldJobobo/miasma.nvim" },
  { "OldJobobo/retro-82.nvim" },
  { "omacom-io/lumon.nvim" },
}

-- Lê o tema atual: devolve o spec do plugin do tema e o nome do colorscheme.
local function read_theme()
  local ok, spec = pcall(dofile, theme_file)
  if not ok or type(spec) ~= "table" then
    return nil, fallback
  end
  local plugin, colorscheme = nil, fallback
  for _, s in ipairs(spec) do
    if s[1] == "LazyVim/LazyVim" then
      colorscheme = (s.opts and s.opts.colorscheme) or colorscheme
    elseif s[1] and not plugin then
      plugin = s
    end
  end
  return plugin, colorscheme
end

-- Aplica o tema atual: carrega o plugin, roda o setup com as cores do tema
-- (temas gerados pelo Omarchy usam o aether com opts) e ativa o colorscheme.
local function apply_theme()
  local plugin, colorscheme = read_theme()
  vim.cmd("highlight clear")
  vim.o.background = "dark"

  if plugin then
    local name = plugin.name or plugin[1]:match("[^/]+$")
    local lazy_plugin = require("lazy.core.config").plugins[name]
    if lazy_plugin then
      require("lazy").load({ plugins = { name } })
      if plugin.opts then
        local main = require("lazy.core.loader").get_main(lazy_plugin)
        if main then
          pcall(function() require(main).setup(plugin.opts) end)
        end
      end
    end
  end

  if not pcall(vim.cmd.colorscheme, colorscheme) then
    vim.notify("Tema do Omarchy: colorscheme '" .. colorscheme .. "' não encontrado", vim.log.levels.WARN)
    pcall(vim.cmd.colorscheme, fallback)
  end
  vim.api.nvim_exec_autocmds("ColorScheme", { modeline = false })
end

-- Observa a pasta do tema atual; o Omarchy a substitui inteira ao trocar de tema.
local function watch_theme()
  local watcher = vim.uv.new_fs_event()
  local timer = vim.uv.new_timer()
  if not watcher or not timer then
    return
  end
  watcher:start(state_dir, {}, function()
    -- Várias mudanças chegam juntas durante a troca; aplica uma vez só, no fim.
    timer:stop()
    timer:start(500, 0, vim.schedule_wrap(apply_theme))
  end)
end

local specs = {}
for _, t in ipairs(themes) do
  specs[#specs + 1] = vim.tbl_extend("force", t, { lazy = true, priority = 1000 })
end

-- Plugin do tema atual: carregado já na abertura, com as opções do Omarchy.
local current = read_theme()
if current then
  specs[#specs + 1] = vim.tbl_extend("force", current, { lazy = false, priority = 1000 })
end

-- Aplica o tema depois do plugin dele (prioridade menor = carrega depois).
specs[#specs + 1] = {
  name = "omarchy-theme",
  dir = vim.fn.stdpath("config"),
  lazy = false,
  priority = 999,
  config = function()
    apply_theme()
    watch_theme()
  end,
}

return specs
