vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "

vim.keymap.set("n", "<leader>ya", ":%y+<CR>", { desc = "Yank entire file" })
vim.keymap.set("n", "<leader>pa", ":!php artisan<CR>")

