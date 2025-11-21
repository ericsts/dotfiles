-- nvim/lua/ericsts/plugins/keymaps.lua
return {
  {
    "nvim-lua/plenary.nvim", -- dummy plugin só pra registrar atalhos
    keys = {
      { "<leader>ya", ":%y+<CR>", desc = "Yank entire file" },
      { "<C-h>", "<C-w>h", desc = "Move to left split" },
      { "<C-j>", "<C-w>j", desc = "Move to below split" },
      { "<C-k>", "<C-w>k", desc = "Move to upper split" },
      { "<C-l>", "<C-w>l", desc = "Move to right split" },
    },
  },
}
