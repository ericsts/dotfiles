-- nvim/lua/ericsts/plugins/harpoon.lua
-- HARPOON: Marcador rápido de arquivos — navegue entre até 4 arquivos
-- "pinados" sem precisar de Telescope ou Neo-tree.
--
-- COMO FUNCIONA:
--   Você adiciona arquivos à lista do Harpoon e depois salta entre eles
--   diretamente pelos números 1-4 ou pelos atalhos next/prev.
--   A lista fica salva por projeto (detectado pelo diretório raiz git).
--
-- FLUXO DE USO:
--   1. Abra o arquivo que quer marcar → <leader>ha  (add)
--   2. Repita para outros arquivos (até 4)
--   3. <leader>hh  para ver/reordenar a lista
--   4. <leader>1-4 para pular direto ao arquivo desejado

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()

    vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Harpoon: add file" })
    vim.keymap.set("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon: toggle menu" })

    vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon: file 1" })
    vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon: file 2" })
    vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon: file 3" })
    vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon: file 4" })

    vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end, { desc = "Harpoon: next file" })
    vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end, { desc = "Harpoon: prev file" })
  end
}
