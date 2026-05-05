-- nvim/lua/ericsts/plugins/lazygit.lua
-- LAZYGIT: Abre a TUI do LazyGit dentro de uma janela flutuante do Neovim.
-- LazyGit é um cliente Git visual com navegação por teclado para commits,
-- diffs, branches, stash, rebase interativo, e muito mais.
--
-- COMO FUNCIONA:
--   <leader>gg  → abre LazyGit na raiz do repositório
--   <leader>gL  → abre LazyGit com histórico do arquivo atual em foco
--   Dentro do LazyGit: 'q' fecha, '?' mostra ajuda, Enter confirma ação
--
-- PRÉ-REQUISITO: lazygit precisa estar instalado no sistema
--   Fedora: sudo dnf install lazygit  |  brew install lazygit

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
