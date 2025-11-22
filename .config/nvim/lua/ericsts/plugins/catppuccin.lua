-- nvim/lua/ericsts/plugins/catppuccin.lua
-- CATPPUCCIN: Tema de cores suave e moderno
-- Variantes: latte (claro), frappe, macchiato, mocha (escuro)

-- Função para deixar o fundo transparente
local function enable_transparency()
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
end

return {
  "catppuccin/nvim",
  lazy = false,    -- Carrega imediatamente
  name = "catppuccin",
  priority = 1000, -- Carrega antes de outros plugins (importante para temas)
  config = function()
    require("catppuccin").setup({
      flavour = "auto", -- auto detecta tema do sistema
      background = {
          light = "latte",  -- Tema claro
          dark = "mocha",   -- Tema escuro
      },
      -- OPÇÕES ADICIONAIS:
      -- transparent_background = true, -- Fundo transparente nativo
      -- integrations = {
      --   telescope = true,
      --   neotree = true,
      --   gitsigns = true,
      -- },
    })

    enable_transparency() -- Aplica transparência
    vim.cmd.colorscheme "catppuccin"
  end
}

-- OUTROS TEMAS POPULARES (alternativas):
-- "folke/tokyonight.nvim"
-- "navarasu/onedark.nvim"
-- "EdenEast/nightfox.nvim"
-- "rebelot/kanagawa.nvim"
