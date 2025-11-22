-- nvim/lua/ericsts/plugins/laravel.lua
-- Plugins específicos para desenvolvimento Laravel

return {
  -- === VIM-PROJECTIONIST ===
  -- Permite navegar entre arquivos relacionados (Model <-> Controller, etc)
  {
    "tpope/vim-projectionist",
    ft = "php", -- Só carrega em arquivos PHP
  },

  -- === LARAVEL.NVIM ===
  -- Plugin completo para Laravel: artisan commands, routes, etc
  {
    "adalessa/laravel.nvim",
    ft = "php",
    dependencies = {
      "nvim-telescope/telescope.nvim", -- Usa Telescope para menus
      "tpope/vim-dotenv",              -- Lê arquivos .env
      "MunifTanjim/nui.nvim",          -- UI components
    },
    opts = {}, -- Configuração padrão

    -- FEATURES:
    -- - :Laravel artisan <comando>
    -- - :Laravel routes (ver rotas)
    -- - Telescope integration
    -- - Autocompletar para artisan commands
  },
}

-- DICA: Explore os comandos com :Laravel <Tab>
