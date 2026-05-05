-- nvim/lua/ericsts/plugins/todo-comments.lua
-- TODO-COMMENTS

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
