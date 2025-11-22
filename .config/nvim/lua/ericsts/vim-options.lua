-- nvim/lua/ericsts/vim-options.lua
vim.cmd("set expandtab")     -- Converte tabs em espaços
vim.cmd("set tabstop=2")     -- Tamanho visual de um tab = 2 espaços
vim.cmd("set softtabstop=2") -- Número de espaços ao pressionar Tab
vim.cmd("set shiftwidth=2")  -- Número de espaços para indentação automática

vim.g.mapleader = " "

vim.keymap.set("n", "<leader>ya", ":%y+<CR>", { desc = "Yank entire file" })
