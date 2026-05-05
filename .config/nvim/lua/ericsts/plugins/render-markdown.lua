-- nvim/lua/ericsts/plugins/render-markdown.lua
-- RENDER-MARKDOWN: Renderiza arquivos Markdown diretamente no buffer do Neovim.
-- Em vez de ver a sintaxe crua (# Título, **negrito**), você vê o resultado
-- formatado: cabeçalhos com cores, blocos de código com syntax highlight,
-- listas com bullets reais, etc. — sem sair do editor.
--
-- COMO FUNCIONA:
--   Abre qualquer arquivo .md → renderização acontece automaticamente
--   O texto continua editável normalmente; a visualização é "ao vivo"
--
-- ATIVADO PARA: somente arquivos markdown (ft = { "markdown" })

return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  ft = { "markdown" },
  opts = {
    heading = { enabled = true },
    code    = { enabled = true },
    bullet  = { enabled = true },
  },
}
