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

      require("telescope").setup({
        defaults = {
          -- Passa --hidden para o ripgrep incluir arquivos/diretórios ocultos (.config, .env, etc.)
          -- --glob=!.git/* evita entrar na pasta .git
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "--glob=!.git/*",
          },
        },
      })

      -- Ctrl+P: busca arquivos incluindo ocultos
      vim.keymap.set("n", "<C-p>", function()
        builtin.find_files({ hidden = true, no_ignore = false })
      end, { desc = "Find files (including hidden)" })

      -- <leader>fg: grep em todos os arquivos incluindo ocultos
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep (including hidden)" })

      -- Command palette: busca e executa qualquer comando/atalho do Neovim
      vim.keymap.set("n", "<leader>fc", builtin.commands,  { desc = "Command palette (comandos)" })
      vim.keymap.set("n", "<leader>fk", builtin.keymaps,   { desc = "Command palette (atalhos)" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Buscar documentação (:help)" })
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
