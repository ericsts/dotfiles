-- nvim/lua/ericsts/plugins/tailwind.lua
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tailwindcss = {
          filetypes = { "php", "blade", "html", "css", "javascript", "typescript" },
        },
      },
    },
  },
}
