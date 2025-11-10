local function enable_transparency()
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
end
return {
  {
    "folke/tokyonight.nvim",
--    lazy = false, -- make sure we load this during startup if it is your main colorscheme
--    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      --vim.cmd([[colorscheme tokyonight]])
      vim.cmd.colorscheme "tokyonight"
      vim.cmd('hi Directory guibg=NONE')
      vim.cmd('hi SignColumn guibg=NONE')
      enable_transparency()
    end
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
	"nvim-tree/nvim-web-devicons",
    },
    opts = {
	theme = 'tokyonight',
    }
  },
}

