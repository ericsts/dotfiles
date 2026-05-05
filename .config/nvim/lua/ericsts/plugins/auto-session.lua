-- nvim/lua/ericsts/plugins/auto-session.lua
-- AUTO-SESSION: Salva e restaura sessões do Neovim por diretório de trabalho.
-- Cada pasta do projeto tem sua própria sessão: buffers abertos, splits,
-- posição do cursor, etc. são preservados entre fechamentos do editor.
--
-- COMO FUNCIONA:
--   auto_restore_enabled = false → você escolhe QUANDO restaurar (não automático)
--   A sessão é vinculada ao cwd (Current Working Directory) do Neovim.
--
-- FLUXO DE USO:
--   1. Trabalhe normalmente no projeto, abra arquivos, splits, etc.
--   2. <leader>ws  → salva a sessão atual
--   3. Feche o Neovim. Na próxima vez que abrir no mesmo diretório:
--   4. <leader>wr  → restaura exatamente como estava

return {
  "rmagatti/auto-session",
  config = function()
    local auto_session = require("auto-session")

    auto_session.setup({
      auto_restore_enabled = true,
      auto_session_suppress_dirs = { "~/", "~/dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
    })

    local keymap = vim.keymap

    keymap.set("n", "<leader>wr", "<cmd>AutoSession restore<CR>", { desc = "Restore session for cwd" }) -- restore last workspace session for current directory
    keymap.set("n", "<leader>ws", "<cmd>AutoSession save<CR>", { desc = "Save session for auto session root dir" }) -- save workspace session for current working directory
  end,
}
