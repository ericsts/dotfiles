-- nvim/lua/ericsts/plugins/completions.lua
-- Sistema de autocompletar (completion) do Neovim
-- Mostra sugestões enquanto você digita

return {
  -- === CMP-NVIM-LSP: Fonte de completion do LSP ===
  -- Fornece sugestões vindas dos servidores LSP
  {
    "hrsh7th/cmp-nvim-lsp"
  },

  -- === LUASNIP: Engine de snippets ===
  -- Permite usar e criar snippets de código reutilizáveis
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "saadparwaiz1/cmp_luasnip",        -- Integração LuaSnip + nvim-cmp
      "rafamadriz/friendly-snippets",    -- Coleção de snippets prontos
    },
  },

  -- === NVIM-CMP: Motor principal de completion ===
  -- Plugin que gerencia todo o sistema de autocompletar
  {
    "hrsh7th/nvim-cmp",
    config = function()
      local cmp = require("cmp")

      -- Carrega snippets do VSCode (friendly-snippets)
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        -- Configuração de snippets
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },

        -- Janelas com bordas
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        -- === ATALHOS DE COMPLETION ===
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),      -- Scroll docs para cima
          ["<C-f>"] = cmp.mapping.scroll_docs(4),       -- Scroll docs para baixo
          ["<C-Space>"] = cmp.mapping.complete(),       -- Abre menu de completion
          ["<C-e>"] = cmp.mapping.abort(),              -- Fecha menu
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Confirma seleção
        }),

        -- === FONTES DE COMPLETION (em ordem de prioridade) ===
        sources = cmp.config.sources({
          { name = "nvim_lsp" },  -- Sugestões do LSP (principal)
          { name = "luasnip" },   -- Sugestões de snippets
        }, {
          { name = "buffer" },    -- Palavras do buffer atual (fallback)
        }),
      })
    end,
  },
}
