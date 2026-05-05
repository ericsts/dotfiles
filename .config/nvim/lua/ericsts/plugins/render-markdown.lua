-- nvim/lua/ericsts/plugins/render-markdown.lua
-- READER-MARKDOWN:

return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  ft = { "markdown" },
  opts = {
    heading = { enabled = true },
    code    = { enabled = true },
    bullet  = { enabled = true },
  },
}
