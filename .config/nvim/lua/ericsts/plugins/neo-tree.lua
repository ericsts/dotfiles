-- nvim/lua/ericsts/plugins/neo-tree.lua
-- NEO-TREE: Explorador de arquivos lateral (como NERDTree)
-- Mostra estrutura de pastas, git status, etc.

return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons", -- Ícones bonitos
  },
  lazy = false, -- Sempre disponível
  config = function()
    require("neo-tree").setup({
      -- Ícones de diagnóstico LSP exibidos à direita do nome do arquivo
      -- Usa os mesmos nf-md-* definidos em lsp-config.lua
      default_component_configs = {
        diagnostics = {
          symbols = {
            error = "󰅚",
            warn  = "󰀪",
            hint  = "󰌶",
            info  = "󰋽",
          },
        },
      },

      filesystem = {
        follow_current_file = { enabled = true }, -- Foca no arquivo atual
        filtered_items = {
          visible = true,       -- Mostra arquivos filtrados
          hide_dotfiles = false, -- Não esconde arquivos com .
          hide_gitignored = false, -- Mostra arquivos do .gitignore
        },
      },

      -- Fecha Neo-tree automaticamente ao abrir arquivo
      event_handlers = {
        {
          event = "file_opened",
          handler = function()
            require("neo-tree.command").execute({ action = "close" })
          end,
        },
      },

      -- === NAVEGAÇÃO TIPO VIM ===
      window = {
        mappings = {
          ["<space>"] = "toggle_node",    -- Espaço: abre/fecha pasta
          ["h"] = "navigate_up",          -- h: vai para pasta pai
          ["l"] = "open",                 -- l: abre arquivo/pasta
          ["<BS>"] = "close_node",        -- Backspace: fecha pasta
          ["<CR>"] = "open",              -- Enter: abre arquivo
        },
      },
    })

    -- === ATALHOS GLOBAIS ===
    -- Ctrl+N: toggle Neo-tree
    vim.keymap.set("n", "<C-n>", ":Neotree toggle<CR>", { desc = "Toggle Neo-tree" })

    -- <leader>e: revela arquivo atual no Neo-tree
    vim.keymap.set("n", "<leader>e", ":Neotree filesystem reveal left<CR>", { desc = "Reveal in Neo-tree" })

    -- <leader>h: toggle arquivos ocultos
    vim.keymap.set("n", "<leader>h", ":Neotree toggle_hidden<CR>", { desc = "Toggle hidden files" })
  end
}
