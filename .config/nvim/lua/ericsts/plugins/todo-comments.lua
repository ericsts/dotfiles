-- nvim/lua/ericsts/plugins/todo-comments.lua
-- TODO-COMMENTS: Destaca e navega por comentários especiais no código.
-- Reconhece automaticamente: TODO, FIXME, HACK, WARN, NOTE, BUG, PERF, TEST
--
-- COMO FUNCIONA:
--   Basta escrever "-- TODO: descrição" e o comentário ganha destaque visual
--   colorido. Você pode listar todos eles com Telescope ou navegar entre eles.
--
-- USO:
--   <leader>ft  → abre Telescope com lista de todos os TODOs do projeto
--   ]t / [t     → pula para o próximo/anterior TODO no arquivo atual

return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {},
  keys = {
    { "<leader>ft", "<cmd>TodoTelescope<CR>",                                     desc = "Buscar TODOs" },
    { "]t",         function() require("todo-comments").jump_next() end,           desc = "Próximo TODO" },
    { "[t",         function() require("todo-comments").jump_prev() end,           desc = "TODO anterior" },
  },
}
