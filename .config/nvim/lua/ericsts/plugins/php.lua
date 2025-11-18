-- lua/ericsts/plugins/php.lua
return {
  -- Integração com Pint
  {
    "nvim-lua/plenary.nvim",
    ft = "php",
    keys = {
      { "<leader>pf", ":!pint %<CR>", desc = "Format file with Pint" },
      {
        "<leader>ps",
        ":!git diff --name-only --cached --diff-filter=ACM | grep -E '\\.php$' | xargs pint<CR>",
        desc = "Format staged PHP files with Pint",
      },
      { "<leader>pa", ":!php artisan <space>", desc = "Run Laravel artisan command" },
    },
  },
}


--return {
--  {
--    "neovim/nvim-lspconfig",
--    opts = {
--      servers = {
--        intelephense = {},
--      },
--    },
--  },

  -- Laravel helper navigation
--  {
--    "noahfrederick/vim-laravel",
--    ft = "php",
--  },

  -- Pint format
--  {
--    keys = {
--      {
--        "<leader>pf",
--        ":!pint %<CR>",
 --       desc = "Format file with Pint",
 --     },
 --   },
 -- },

  -- Pint staged for Git
--  {
--    keys = {
--      {
--        "<leader>ps",
--        ":!git diff --name-only --cached --diff-filter=ACM | grep -E '\\.php$' | xargs pint<CR>",
--        desc = "Format staged PHP files with Pint",
--      },
--    },
--  },

  -- Artisan helpers
--  {
--    ft = "php",
--    keys = {
--      { "<leader>pa", ":!php artisan <space>", desc = "Artisan" },
--    },
--  },
-- }
