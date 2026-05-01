-- vim-fugitive — git avançado: commits granulares, diff, blame, merge
return {
  "tpope/vim-fugitive",
  keys = {
    { "<leader>gG", "<cmd>Git<CR>",           desc = "Fugitive: status" },
    { "<leader>gB", "<cmd>Git blame<CR>",     desc = "Fugitive: blame (arquivo)" },
    { "<leader>gM", "<cmd>Git mergetool<CR>", desc = "Fugitive: merge tool" },
  },
}
