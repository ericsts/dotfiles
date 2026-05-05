-- nvim/lua/ericsts/plugins/lualine.lua
-- LUALINE:

return {
  "nvim-lualine/lualine.nvim",
  config = function()
    require('lualine').setup({
      options = {
        theme = 'dracula'
      }
    })
  end
}
