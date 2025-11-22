-- nvim/lua/ericsts/plugins/lsp-config.lua
-- Configuração completa de LSP (Language Server Protocol)
-- LSP fornece recursos avançados: autocompletar, diagnósticos, refatoração, etc.

return {
  -- === MASON: Gerenciador de LSP, DAP, linters, formatters ===
  -- Mason instala e gerencia servidores de linguagem automaticamente
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
    end,
  },

  -- === MASON-LSPCONFIG: Integração entre Mason e nvim-lspconfig ===
  -- Faz a "ponte" entre o Mason (instalador) e o lspconfig (configurador)
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      -- Servidores LSP que serão instalados automaticamente
      ensure_installed = {
        "lua_ls",       -- LSP para Lua
        "intelephense", -- LSP para PHP
        "tailwindcss",  -- LSP para Tailwind CSS
      },
    },
  },

  -- === NVIM-LSPCONFIG: Configurador de LSP ===
  -- Plugin principal que conecta o Neovim aos servidores LSP
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" }, -- Carrega ao abrir arquivos
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      { "antosha417/nvim-lsp-file-operations", config = true }, -- Operações de arquivo via LSP
      { "folke/lazydev.nvim", opts = {} }, -- Autocompletar para configs Lua do Neovim
    },
    config = function()
      -- Função executada quando um LSP se conecta a um buffer
      local function on_attach(client, bufnr)
        local keymap = vim.keymap
        local opts = { buffer = bufnr, silent = true }

        -- === ATALHOS LSP ===
        opts.desc = "Show LSP references"
        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

        opts.desc = "Show LSP definition"
        keymap.set("n", "gd", vim.lsp.buf.definition, opts)

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", function()
          vim.diagnostic.jump({ count = -1, float = true })
        end, opts)

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", function()
          vim.diagnostic.jump({ count = 1, float = true })
        end, opts)

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts)

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
      end

      -- === ÍCONES DE DIAGNÓSTICO ===
      local severity = vim.diagnostic.severity
      vim.diagnostic.config({
        signs = {
          text = {
            [severity.ERROR] = "✘ ",
            [severity.WARN] = "▲ ",
            [severity.HINT] = "⚑ ",
            [severity.INFO] = " ",
          },
        },
      })

      -- Obtém as "capabilities" do autocompletar (cmp)
      -- Isso informa ao LSP o que nosso editor suporta (snippets, etc)
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local lspconfig = require("lspconfig")
      local mason_lspconfig = require("mason-lspconfig")

      -- === CONFIGURAÇÃO AUTOMÁTICA DE TODOS OS SERVIDORES ===
      mason_lspconfig.setup_handlers({
        -- Handler padrão: aplica para TODOS os servidores
        function(server_name)
          lspconfig[server_name].setup({
            capabilities = capabilities,
            on_attach = on_attach,
          })
        end,

        -- === CONFIGURAÇÕES ESPECÍFICAS POR SERVIDOR ===

        -- Lua LS: servidor para Lua
        ["lua_ls"] = function()
          lspconfig.lua_ls.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim" } -- Reconhece 'vim' como global
                },
              },
            },
          })
        end,

        -- Intelephense: servidor para PHP
        ["intelephense"] = function()
          lspconfig.intelephense.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            -- lspconfig já sabe configurar automaticamente
            -- cmd, filetypes, root_dir, etc.
          })
        end,
      })
    end,
  },
}
