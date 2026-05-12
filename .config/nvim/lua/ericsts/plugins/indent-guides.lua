-- nvim/lua/ericsts/plugins/indent-guides.lua
-- INDENT-BLANKLINE: Mostra guias verticais em cada nível de indentação,
-- deixando visível onde blocos (if, for, funções, tags HTML) abrem e fecham.
--
-- FEATURES:
--   - Linhas verticais em cada nível de indentação
--   - Escopo atual destacado em cor diferente (bloco onde o cursor está)
--   - Funciona com Treesitter para detectar escopos corretamente

return {
  "lukas-reineke/indent-blankline.nvim",
  main    = "ibl",
  event   = { "BufReadPre", "BufNewFile" },
  config  = function()
    local hooks = require("ibl.hooks")

    -- Gradiente de cores para os níveis de indentação
    local highlight_colors = {
      "IBLIndent1", "IBLIndent2", "IBLIndent3",
      "IBLIndent4", "IBLIndent5", "IBLIndent6",
    }

    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "IBLIndent1", { fg = "#214969" })
      vim.api.nvim_set_hl(0, "IBLIndent2", { fg = "#1e5e4e" })
      vim.api.nvim_set_hl(0, "IBLIndent3", { fg = "#4a3a6e" })
      vim.api.nvim_set_hl(0, "IBLIndent4", { fg = "#214969" })
      vim.api.nvim_set_hl(0, "IBLIndent5", { fg = "#1e5e4e" })
      vim.api.nvim_set_hl(0, "IBLIndent6", { fg = "#4a3a6e" })
      vim.api.nvim_set_hl(0, "IBLScope",   { fg = "#A277FF" }) -- escopo atual em roxo
    end)

    require("ibl").setup({
      indent = {
        char      = "│",        -- linha vertical sólida
        highlight = highlight_colors,
      },
      scope = {
        enabled   = true,
        highlight = "IBLScope", -- destaca o escopo atual em roxo
        show_start = true,      -- sublinha o início do bloco
        show_end   = false,
      },
      exclude = {
        filetypes = { "help", "alpha", "dashboard", "lazy", "mason", "toggleterm" },
      },
    })
  end,
}
