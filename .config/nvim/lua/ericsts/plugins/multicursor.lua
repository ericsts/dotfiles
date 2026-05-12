-- nvim/lua/ericsts/plugins/multicursor.lua
-- VIM-VISUAL-MULTI: Multi-cursor igual ao VSCode (Ctrl+D).
-- Seleciona a palavra sob o cursor e adiciona cursores nas próximas
-- ocorrências — você edita todas ao mesmo tempo.
--
-- COMO USAR:
--   <C-n>        → seleciona palavra sob o cursor (1ª vez)
--                  → adiciona cursor na próxima ocorrência (vezes seguintes)
--   <C-x>        → pula esta ocorrência e vai para a próxima
--   <C-p>        → desfaz a última seleção adicionada
--   <A-n>        → seleciona TODAS as ocorrências de uma vez
--   Esc          → sai do modo multi-cursor
--
-- COM CURSORES ATIVOS (modo multi-cursor):
--   Edição normal de vim funciona em todos os cursores simultaneamente:
--   c, d, i, a, r, etc.

return {
  "mg979/vim-visual-multi",
  branch = "master",
  init = function()
    vim.g.VM_maps = {
      ["Find Under"]         = "<C-n>",
      ["Find Subword Under"] = "<C-n>",
      ["Select All"]         = "<A-n>",
      ["Skip Region"]        = "<C-x>",
      ["Remove Region"]      = "<C-p>",
    }
    vim.g.VM_highlight_matches = "underline"
  end,
}
