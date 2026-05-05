-- nvim/lua/ericsts/vim-options.lua

vim.cmd("set expandtab")     -- Converte tabs em espaços
vim.cmd("set tabstop=2")     -- Tamanho visual de um tab = 2 espaços
vim.cmd("set softtabstop=2") -- Número de espaços ao pressionar Tab
vim.cmd("set shiftwidth=2")  -- Número de espaços para indentação automática

vim.g.mapleader = " "

vim.keymap.set("n", "<leader>ya", ":%y+<CR>", { desc = "Yank entire file" })

-- Recarrega arquivos modificados externamente (ex: gerados por Claude Code,
-- git pull, formatadores, etc.) sem precisar reiniciar o Neovim.
-- checktime dispara a verificação sempre que o Neovim ganhar foco ou
-- o cursor parar de se mover por um instante.
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  callback = function()
    if vim.fn.mode() ~= "c" then
      vim.cmd("checktime")
    end
  end,
})
