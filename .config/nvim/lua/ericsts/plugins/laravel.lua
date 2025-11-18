-- lua/ericsts/plugins/laravel.lua
return {
  {
    "tpope/vim-projectionist",
    ft = "php",
  },
  {
    "adalessa/laravel.nvim",
    ft = "php",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "tpope/vim-dotenv",
      "MunifTanjim/nui.nvim",
    },
    opts = {},
  },
}
