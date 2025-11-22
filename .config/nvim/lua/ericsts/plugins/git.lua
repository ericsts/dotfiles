-- nvim/lua/ericsts/plugins/git.lua
-- GITSIGNS: Integração com Git (mostra mudanças, blame, etc)
-- Exibe sinais na lateral indicando linhas modificadas/adicionadas/removidas

return {
  "lewis6991/gitsigns.nvim",
  opts = {}, -- Configuração padrão
  keys = {
    -- === ATALHOS GIT ===
    -- <leader>gp: preview das mudanças (hunk)
    {
      "<leader>gp",
      ":Gitsigns preview_hunk<CR>",
      desc = "Preview Git hunk"
    },

    -- <leader>gr: desfaz mudanças (reset hunk)
    {
      "<leader>gr",
      ":Gitsigns reset_hunk<CR>",
      desc = "Reset Git hunk"
    },

    -- <leader>gb: mostra quem modificou a linha (blame)
    {
      "<leader>gb",
      ":Gitsigns blame_line<CR>",
      desc = "Git blame line"
    },

    -- <leader>gd: mostra diff do arquivo
    {
      "<leader>gd",
      ":Gitsigns diffthis<CR>",
      desc = "Git diff this"
    },
  },

  -- FEATURES AUTOMÁTICAS:
  -- - Ícones na lateral: + (adicionado), ~ (modificado), _ (removido)
  -- - [c e ]c para navegar entre mudanças
  -- - Suporta git blame inline
}
