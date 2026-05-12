-- nvim/lua/ericsts/vim-options.lua

vim.cmd("set expandtab")     -- Converte tabs em espaços
vim.cmd("set tabstop=2")     -- Tamanho visual de um tab = 2 espaços
vim.cmd("set softtabstop=2") -- Número de espaços ao pressionar Tab
vim.cmd("set shiftwidth=2")  -- Número de espaços para indentação automática

vim.g.mapleader = " "

-- Números de linha
vim.opt.number         = true  -- número absoluto na linha atual
vim.opt.relativenumber = true  -- números relativos nas demais (útil para saltos: 5j, 3k)

vim.keymap.set("n", "<leader>ya", ":%y+<CR>", { desc = "Yank entire file" })

-- Mover linha(s) para cima/baixo — Alt+k / Alt+j
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==",        { desc = "Mover linha abaixo" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==",        { desc = "Mover linha acima" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv",   { desc = "Mover seleção abaixo" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv",   { desc = "Mover seleção acima" })

-- Duplicar linha abaixo — Alt+Shift+j
vim.keymap.set("n", "<A-J>", "yyp",  { desc = "Duplicar linha abaixo" })
vim.keymap.set("v", "<A-J>", "y'>p", { desc = "Duplicar seleção abaixo" })

-- Comentar linha/seleção — Ctrl+/ (Neovim 0.10+ tem gc nativo)
vim.keymap.set("n", "<C-_>", "gcc", { remap = true, desc = "Toggle comentário" })
vim.keymap.set("v", "<C-_>", "gc",  { remap = true, desc = "Toggle comentário" })

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
