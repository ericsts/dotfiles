-- nvim/lua/ericsts/plugins/trouble.lua
-- TROUBLE: Painel de diagnósticos, erros LSP e quickfix com visual elegante.
-- Substitui a quickfix list e o location list nativos do Neovim com uma
-- interface organizada que mostra erros, warnings, hints agrupados por arquivo.
--
-- COMO FUNCIONA:
--   Abre um painel (geralmente na parte inferior) listando todos os problemas
--   do projeto ou do buffer atual. Clicar/Enter em um item pula para o local.
--
-- MODOS DISPONÍVEIS:
--   diagnostics  → todos os erros do workspace
--   buffer atual → só erros do arquivo aberto
--   symbols      → símbolos LSP do buffer (funções, classes, etc.)
--   lsp          → referências e definições LSP
--   quickfix     → itens da quickfix list

return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {},
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>",                        desc = "Trouble: diagnósticos" },
    { "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",           desc = "Trouble: buffer atual" },
    { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<CR>",                desc = "Trouble: símbolos" },
    { "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<CR>", desc = "Trouble: LSP refs/defs" },
    { "<leader>xq", "<cmd>Trouble qflist toggle<CR>",                             desc = "Trouble: quickfix" },
    {
      "]x",
      function() require("trouble").next({ skip_groups = true, jump = true }) end,
      desc = "Trouble: próximo item",
    },
    {
      "[x",
      function() require("trouble").prev({ skip_groups = true, jump = true }) end,
      desc = "Trouble: item anterior",
    },
  },
}
