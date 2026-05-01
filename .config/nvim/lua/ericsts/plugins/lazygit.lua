return {
  "kdheepak/lazygit.nvim",
  lazy = true,
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>gg", "<cmd>LazyGit<CR>",            desc = "LazyGit" },
    { "<leader>gL", "<cmd>LazyGitCurrentFile<CR>", desc = "LazyGit: histórico do arquivo" },
  },
}
