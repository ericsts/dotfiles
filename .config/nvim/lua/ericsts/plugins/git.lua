-- lua/ericsts/plugins/git.lua
return {
  "lewis6991/gitsigns.nvim",
  opts = {},
  keys = {
    { "<leader>gp", ":Gitsigns preview_hunk<CR>", desc = "Preview Hunk" },
    { "<leader>gr", ":Gitsigns reset_hunk<CR>", desc = "Reset Hunk" },
    { "<leader>gb", ":Gitsigns blame_line<CR>", desc = "Blame line" },
    { "<leader>gd", ":Gitsigns diffthis<CR>", desc = "Diff This" },
  },
}

