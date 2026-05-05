-- nvim/lua/ericsts/plugins/which-key.lua
-- WHICH-KEY: Popup de ajuda que aparece automaticamente quando você para
-- de digitar uma sequência de teclas (ex: <leader>g...).
--
-- COMO FUNCIONA:
--   Pressione <leader> e aguarde ~1 segundo → aparece um menu mostrando
--   todos os atalhos disponíveis a partir daquela tecla, com descrições.
--   Funciona com qualquer prefixo: <leader>, g, z, [, ], etc.
--
-- DICA: Se você esquecer um atalho, comece a digitá-lo e espere o menu.

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {},
}
