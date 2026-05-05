-- nvim/lua/ericsts/plugins/catppuccin.lua
-- CATPPUCCIN: Tema base com cores sobrescritas para casar com o WezTerm
-- As cores abaixo espelham exatamente a paleta definida em ~/.wezterm.lua

return {
  "catppuccin/nvim",
  lazy = false,
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      transparent_background = true, -- usa o fundo/opacidade do WezTerm

      -- Sobrescreve a paleta mocha com as cores exatas do WezTerm
      color_overrides = {
        mocha = {
          -- Fundos (do mais escuro para o mais claro)
          base    = "#011423",
          mantle  = "#011020",
          crust   = "#010d1a",
          -- Superfícies / seleção
          surface0 = "#033259",
          surface1 = "#0a2744",
          surface2 = "#133a5e",
          overlay0 = "#214969",
          overlay1 = "#2d5f82",
          overlay2 = "#3a739b",
          -- Texto
          text     = "#CBE0F0",
          subtext1 = "#a8c8e0",
          subtext0 = "#85b0d0",
          -- Cores de acento (mapeadas das ansi/brights do WezTerm)
          green    = "#44FFB1",
          teal     = "#24EAF7",
          sky      = "#24EAF7",
          blue     = "#0FC5ED",
          sapphire = "#0FC5ED",
          mauve    = "#A277FF",
          lavender = "#A277FF",
          pink     = "#A277FF",
          yellow   = "#FFE073",
          peach    = "#FFE073",
          red      = "#E52E2E",
          flamingo = "#E52E2E",
          rosewater = "#CBE0F0",
        },
      },

      integrations = {
        cmp        = true,
        gitsigns   = true,
        neotree    = true,
        telescope  = { enabled = true },
        treesitter = true,
        which_key  = true,
        alpha      = true,
        trouble    = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors      = { "underline" },
            hints       = { "underline" },
            warnings    = { "underline" },
            information = { "underline" },
          },
        },
      },
    })

    vim.cmd.colorscheme("catppuccin")
  end,
}
