-- lua/ericsts/plugins/lsp-config.lua
return {
  -- Carrega o Mason e suas extensões
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


  {
    "williamboman/mason-lspconfig.nvim",
    -- Este plugin é a "cola" entre o Mason e o nvim-lspconfig
    -- Certifique-se de que ele seja carregado DEPOIS do nvim-lspconfig
    -- dependencies = { "neovim/nvim-lspconfig" },
    opts = {
      -- Lista de servidores LSP que o Mason deve instalar automaticamente
      ensure_installed = {
        "lua_ls",
        "intelephense",
        "tailwindcss",
      },
    },
  },

  -- O GERENCIADOR DE LSP PRINCIPAL
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- Dependências opcionais para UI e funcionalidades extras
      "williamboman/mason-lspconfig.nvim",
      { "antosha417/nvim-lsp-file-operations", config = true },
      { "folke/lazydev.nvim", opts = {} }, -- Para autocompletar em configs .lua
    },
    config = function()
      -- Esta é a função que estava no seu lsp.lua original.
      -- Ela será chamada para CADA servidor LSP que o mason-lspconfig iniciar.
      local function on_attach(client, bufnr)
        local keymap = vim.keymap
        local opts = { buffer = bufnr, silent = true }

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

      -- Configuração dos ícones de diagnóstico
      local severity = vim.diagnostic.severity
      vim.diagnostic.config({
        signs = {
          text = {
            [severity.ERROR] = "✘ ",
            [severity.WARN] = "▲ ",
            [severity.HINT] = "⚑ ",
            [severity.INFO] = " ",
          },
        },
      })

      -- Pega as "capabilities" (capacidades) do plugin de autocompletar (cmp)
      -- Isso diz ao LSP que nosso cliente de autocompletar sabe lidar com snippets, etc.
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Pega o gerenciador do mason-lspconfig
      local lspconfig = require("lspconfig")

      local mason_lspconfig = require("mason-lspconfig")

      -- Configura o mason-lspconfig para usar as 'capabilities' e a função 'on_attach'
      -- para CADA servidor que ele configurar.
      mason_lspconfig.setup_handlers({
        -- Este é o handler padrão que vai rodar para todos os servidores
        function(server_name)
          lspconfig[server_name].setup({
            capabilities = capabilities,
            on_attach = on_attach,
          })
        end,

        -- --- Exceções ---
        -- Aqui você pode sobrescrever configurações para servidores específicos
        ["lua_ls"] = function()
          lspconfig.lua_ls.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
              Lua = {
                diagnostics = { globals = { "vim" } },
              },
            },
          })
        end,

        ["intelephense"] = function()
          lspconfig.intelephense.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            -- As outras configs manuais que você tinha (cmd, filetypes, root_dir)
            -- NÃO SÃO MAIS NECESSÁRIAS. O lspconfig já sabe como fazer isso.
          })
        end,
      })
    end,
  },
}
