-- nvim/lua/ericsts/plugins/terminal.lua
-- TOGGLETERM: Terminal integrado que abre/fecha com um atalho.
-- Suporta múltiplos terminais simultâneos em diferentes direções.
--
-- COMO FUNCIONA:
--   <C-\>  → abre/fecha terminal horizontal na parte inferior
--   persist_mode = true → o terminal lembra o modo (insert/normal) ao reabrir
--   direction: "horizontal" | "vertical" | "float" | "tab"
--
-- DICA: Para criar terminais adicionais numerados:
--   2<C-\> abre o terminal nº 2, 3<C-\> o nº 3, etc.
--   Dentro do terminal, <C-\><C-n> volta para o modo normal do Neovim.

return {
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = {
    { "<C-\\>", desc = "Toggle terminal" },
  },
  opts = {
    open_mapping = [[<C-\>]],
    direction = "horizontal", -- "horizontal" | "vertical" | "float" | "tab"
    size = 15,
    float_opts = {
      border = "curved",
    },
    shade_terminals = false,
    persist_mode = true,
  },
}
