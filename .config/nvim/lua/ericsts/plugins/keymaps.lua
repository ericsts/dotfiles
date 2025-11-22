-- nvim/lua/ericsts/plugins/keymaps.lua
-- Atalhos globais extras (não específicos de plugins)

return {
  {
    "nvim-lua/plenary.nvim", -- Plugin dummy só para registrar atalhos
    keys = {
      -- === COPIAR ARQUIVO INTEIRO ===
      -- <leader>ya: copia todo conteúdo para clipboard
      {
        "<leader>ya",
        ":%y+<CR>",
        desc = "Yank entire file to clipboard"
      },

      -- === NAVEGAÇÃO ENTRE SPLITS ===
      -- Ctrl+H/J/K/L: navega entre janelas divididas
      { "<C-h>", "<C-w>h", desc = "Move to left split" },
      { "<C-j>", "<C-w>j", desc = "Move to below split" },
      { "<C-k>", "<C-w>k", desc = "Move to upper split" },
      { "<C-l>", "<C-w>l", desc = "Move to right split" },
    },
  },
}

-- DICAS DE ATALHOS NATIVOS ÚTEIS:
-- <C-w>v      - split vertical
-- <C-w>s      - split horizontal
-- <C-w>q      - fecha janela atual
-- <C-w>=      - equaliza tamanho das janelas
-- <C-w>o      - fecha todas menos a atual
