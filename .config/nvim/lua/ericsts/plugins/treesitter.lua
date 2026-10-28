-- nvim/lua/ericsts/plugins/treesitter.lua
-- TREESITTER: Parser de código avançado
-- Fornece syntax highlighting preciso, indentação inteligente,
-- seleção de texto baseada em estrutura (text objects), etc.

return {
  "nvim-treesitter/nvim-treesitter",
  branch = 'master',
  lazy = false, -- Sempre carrega (não é lazy)
  build = ":TSUpdate", -- Atualiza parsers após instalar
  config = function()
    local config = require("nvim-treesitter.configs")
    config.setup({
      -- Linguagens que terão parsers instalados
      ensure_installed = {
        "lua", "javascript", "typescript", "php",
        "html", "css", "json", "yaml", "markdown",
        "bash", "dockerfile", "sql",
        "go", "gomod", "gosum", "gowork"
      },

      -- === FEATURES ===
      highlight = {
        enable = true, -- Ativa syntax highlighting avançado
      },
      indent = {
        enable = true, -- Ativa indentação inteligente
      },

      -- === FEATURES OPCIONAIS (você pode ativar) ===
      -- incremental_selection = {
      --   enable = true,
      --   keymaps = {
      --     init_selection = "gnn",
      --     node_incremental = "grn",
      --     scope_incremental = "grc",
      --     node_decremental = "grm",
      --   },
      -- },
    })
  end
}
