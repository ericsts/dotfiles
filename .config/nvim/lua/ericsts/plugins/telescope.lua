-- nvim/lua/ericsts/plugins/telescope.lua
-- TELESCOPE: Fuzzy finder ultra poderoso
-- Busca arquivos, texto, comandos, símbolos LSP, etc.

return {
  -- === TELESCOPE CORE ===
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' }, -- Biblioteca de funções utilitárias
    config = function()
      local builtin = require("telescope.builtin")

      -- === ATALHOS PRINCIPAIS ===
      -- Ctrl+P: Busca arquivos (como no VSCode)
      vim.keymap.set('n', '<C-p>', builtin.find_files, { desc = "Find files" })

      -- <leader>fg: Busca texto em todos os arquivos (grep)
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Live grep" })
    end
  },

  -- === TELESCOPE UI SELECT ===
  -- Substitui menus nativos do Neovim por interface do Telescope
  -- Exemplo: menu de code actions fica muito mais bonito
  {
    'nvim-telescope/telescope-ui-select.nvim',
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({
              -- Pode adicionar mais opções aqui
            })
          }
        }
      })
      require("telescope").load_extension("ui-select")
    end
  }
}
