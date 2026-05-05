-- nvim/lua/ericsts/plugins/lualine.lua
-- LUALINE: Barra de status moderna na parte inferior do Neovim
-- Mostra: modo atual, branch git, diagnósticos LSP, nome do arquivo,
-- tipo de arquivo, posição do cursor e progresso no arquivo.
-- Usa o tema catppuccin para casar com as cores do WezTerm.

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup({
      options = {
        theme = "auto", -- herda cores do colorscheme ativo (catppuccin-mocha)
        globalstatus = true,        -- uma única barra para todas as janelas
        component_separators = { left = "", right = "" },
        section_separators   = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } }, -- path=1: caminho relativo
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    })
  end,
}
