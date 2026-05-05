-- nvim/lua/ericsts/plugins/autopairs.lua
-- AUTOPAIRS: Fecha automaticamente pares de caracteres ao digitar.
-- Funciona com: () [] {} "" '' `` <> e mais.
--
-- COMO FUNCIONA:
--   Digite '('  → insere '()' e posiciona o cursor entre os parênteses
--   Digite '"'  → insere '""' com cursor no meio
--   Pressione BS dentro de um par vazio → apaga ambos
--   Tem integração com nvim-cmp: ao confirmar completion com CR,
--   o autopairs cuida de não duplicar o fechamento.
--
-- Não exige configuração manual — os defaults cobrem os casos comuns.

return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {},
}
