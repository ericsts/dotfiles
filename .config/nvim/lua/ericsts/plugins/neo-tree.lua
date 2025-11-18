-- lua/ericsts/plugins/neo-tree.lua
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  lazy = false,
  config = function()
    require("neo-tree").setup({
      filesystem = {
        follow_current_file = true,
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
      event_handlers = {
        {
          event = "file_opened",
          handler = function()
            require("neo-tree.command").execute({ action = "close" })
          end,
        },
      },
      window = {
        mappings = {
          ["<space>"] = "toggle_node",
          ["h"] = "navigate_up",
          ["l"] = "open",
          ["<BS>"] = "close_node",
          ["<CR>"] = "open",
        },
      },
    })

    vim.keymap.set("n", "<C-n>", ":Neotree toggle<CR>")
    -- vim.keymap.set("n", "<C-n>", ":Neotree reveal<CR>")
    -- vim.keymap.set('n', '<C-n>', ':Neotree filesystem reveal left<CR>', {})
    vim.keymap.set("n", "<leader>e", ":Neotree filesystem reveal left<CR>")
    vim.keymap.set("n", "<leader>h", ":Neotree toggle_hidden<CR>", {})

  end

}

