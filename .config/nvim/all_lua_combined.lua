-- nvim/lua/ericsts/plugins/terminal.lua
-- TERMINAL
return {
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = {
    { "<C-\\>", desc = "Toggle terminal" },
  },
  opts = {
    open_mapping = [[<C-\>]],
    direction = "horizontal", -- "horizontal" | "vertical" | "float" | "tab"
    size = 15,
    float_opts = {
      border = "curved",
    },
    shade_terminals = false,
    persist_mode = true,
  },
}

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

-- nvim/lua/ericsts/plugins/completions.lua
-- Sistema de autocompletar (completion) do Neovim
-- Mostra sugestões enquanto você digita
return {
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-cmdline" },
  { "hrsh7th/cmp-path" },

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

      -- Completion para a linha de comando (:comandos)
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })

      -- Completion para busca (/ e ?)
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

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
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
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

-- flash.nvim — navegação turbo: pule para qualquer texto visível
-- NOTA: 's' substitui o comando nativo 's' (substitute char → use 'cl' no lugar)
return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash: jump" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash: treesitter" },
    { "r", mode = "o",               function() require("flash").remote() end,             desc = "Flash: remote" },
    { "R", mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Flash: treesitter search" },
  },
}

-- nvim/lua/ericsts/plugins/test.lua
-- NEOTEST: Framework para rodar testes dentro do Neovim
-- Mostra resultados inline, com interface visual
return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",  -- Fix para performance
      "olimorris/neotest-phpunit",        -- Adapter para PHPUnit/Pest
    },
    config = function()
      require("neotest").setup({
        adapters = {
          -- Configura para usar PEST (framework de testes Laravel)
          require("neotest-phpunit")({
            phpunit_cmd = function()
              return "vendor/bin/pest" -- Usa Pest ao invés de PHPUnit
            end,
          }),
        },
      })

      -- === ATALHOS DE TESTES ===
      -- <leader>tr: roda teste mais próximo do cursor
      vim.keymap.set("n", "<leader>tr", function()
        require("neotest").run.run()
      end, { desc = "Run nearest test" })

      -- <leader>tf: roda todos os testes do arquivo atual
      vim.keymap.set("n", "<leader>tf", function()
        require("neotest").run.run(vim.fn.expand("%"))
      end, { desc = "Run all tests in file" })

      -- <leader>ts: toggle resumo dos testes
      vim.keymap.set("n", "<leader>ts", function()
        require("neotest").summary.toggle()
      end, { desc = "Toggle test summary" })

      -- OUTROS COMANDOS ÚTEIS (adicione se quiser):
      -- <leader>to: abre output do último teste
      -- vim.keymap.set("n", "<leader>to", function()
      --   require("neotest").output.open()
      -- end, { desc = "Open test output" })
    end,
  },
}

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
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",       -- LSP para Lua
          "intelephense", -- LSP para PHP
          "tailwindcss",  -- LSP para Tailwind CSS
          "gopls",        -- LSP para Go
        },
        automatic_installation = true,
      })
    end,
  },

  -- === NVIM-LSPCONFIG: Configurador de LSP ===
  -- Plugin principal que conecta o Neovim aos servidores LSP
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      { "antosha417/nvim-lsp-file-operations", config = true },
      { "folke/lazydev.nvim", opts = {} },
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
      local has_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp_lsp.default_capabilities() or {}
      )

      -- === CONFIGURAÇÃO USANDO vim.lsp.config (Neovim 0.11+) ===
      
      -- Lua LS
      vim.lsp.config("lua_ls", {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" }
            },
            workspace = {
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })

      -- Intelephense (PHP)
      vim.lsp.config("intelephense", {
        cmd = { "intelephense", "--stdio" },
        filetypes = { "php" },
        root_markers = { "composer.json", ".git" },
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- Tailwind CSS
      vim.lsp.config("tailwindcss", {
        cmd = { "tailwindcss-language-server", "--stdio" },
        filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
        root_markers = { "tailwind.config.js", "tailwind.config.cjs", "tailwind.config.ts", ".git" },
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- Go
      vim.lsp.config("gopls", {
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        root_markers = { "go.mod", "go.work", ".git" },
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          gopls = {
            analyses = { unusedparams = true },
            staticcheck = true,
            gofumpt = true,
          },
        },
      })

      -- Habilita os servidores LSP automaticamente
      vim.lsp.enable({ "lua_ls", "intelephense", "tailwindcss", "gopls" })
    end,
  },
}

-- nvim/lua/ericsts/plugins/tailwind.lua
-- Configuração específica para TAILWIND CSS LSP
-- Ativa autocompletar de classes Tailwind em arquivos PHP/Blade
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tailwindcss = {
          -- Tipos de arquivo onde Tailwind funcionará
          filetypes = {
            "php",        -- PHP puro
            "blade",      -- Templates Blade do Laravel
            "html",
            "css",
            "javascript",
            "typescript"
          },
          -- DICA: Se usar Alpine.js, adicione x-bind:class ao experimental.classRegex
        },
      },
    },
  },
}

-- FEATURES:
-- - Autocompletar de classes Tailwind
-- - Preview de cores inline
-- - Lint para classes inválidas
-- - Sugestões de classes similares
-- nvim/lua/ericsts/plugins/php.lua
-- Ferramentas específicas para PHP/Laravel
return {
  -- === INTEGRAÇÃO COM LARAVEL PINT ===
  -- Pint é o formatador oficial do Laravel
  {
    "nvim-lua/plenary.nvim", -- Necessário para rodar comandos shell
    ft = "php", -- Só carrega em arquivos PHP
    keys = {
      -- === ATALHOS PINT ===
      -- <leader>pf: formata arquivo atual
      {
        "<leader>pf",
        ":!pint %<CR>",
        desc = "Format file with Pint"
      },

      -- <leader>ps: formata arquivos staged do git
      {
        "<leader>ps",
        ":!git diff --name-only --cached --diff-filter=ACM | grep -E '\\.php$' | xargs pint<CR>",
        desc = "Format staged PHP files with Pint",
      },

      -- <leader>pa: executa comando artisan (com autocompletar)
      {
        "<leader>pa",
        ":!php artisan<space>",
        desc = "Run Laravel artisan command"
      },
    },
  },
}

-- DICA: Para formatar automaticamente ao salvar:
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = "*.php",
--   callback = function()
--     vim.cmd("silent !pint %")
--   end,
-- })
-- nvim/lua/ericsts/plugins/laravel.lua
-- Plugins específicos para desenvolvimento Laravel
return {
  -- === VIM-PROJECTIONIST ===
  -- Permite navegar entre arquivos relacionados (Model <-> Controller, etc)
  {
    "tpope/vim-projectionist",
    ft = "php", -- Só carrega em arquivos PHP
  },

  -- === LARAVEL.NVIM ===
  -- Plugin completo para Laravel: artisan commands, routes, etc
  {
    "adalessa/laravel.nvim",
    ft = "php",
    dependencies = {
      "nvim-telescope/telescope.nvim", -- Usa Telescope para menus
      "tpope/vim-dotenv",              -- Lê arquivos .env
      "MunifTanjim/nui.nvim",          -- UI components
    },
    opts = {}, -- Configuração padrão

    -- FEATURES:
    -- - :Laravel artisan <comando>
    -- - :Laravel routes (ver rotas)
    -- - Telescope integration
    -- - Autocompletar para artisan commands
  },
}

-- DICA: Explore os comandos com :Laravel <Tab>
-- nvim/lua/ericsts/plugins/keymaps.lua
-- Atalhos globais extras (não específicos de plugins)
return {
  {
    "nvim-lua/plenary.nvim", -- Plugin dummy só para registrar atalhos
    keys = {
      -- === COPIAR ARQUIVO INTEIRO ===
      -- <leader>ya: copia todo conteúdo para clipboard
      {
        "<leader>ya",
        ":%y+<CR>",
        desc = "Yank entire file to clipboard"
      },

      -- === NAVEGAÇÃO ENTRE SPLITS ===
      -- Ctrl+H/J/K/L: navega entre janelas divididas
      { "<C-h>", "<C-w>h", desc = "Move to left split" },
      { "<C-j>", "<C-w>j", desc = "Move to below split" },
      { "<C-k>", "<C-w>k", desc = "Move to upper split" },
      { "<C-l>", "<C-w>l", desc = "Move to right split" },
    },
  },
}

-- DICAS DE ATALHOS NATIVOS ÚTEIS:
-- <C-w>v      - split vertical
-- <C-w>s      - split horizontal
-- <C-w>q      - fecha janela atual
-- <C-w>=      - equaliza tamanho das janelas
-- <C-w>o      - fecha todas menos a atual
-- nvim/lua/ericsts/plugins/lazygit.lua
-- LAZYGIT:
return {
  "kdheepak/lazygit.nvim",
  lazy = true,
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>gg", "<cmd>LazyGit<CR>",            desc = "LazyGit" },
    { "<leader>gL", "<cmd>LazyGitCurrentFile<CR>", desc = "LazyGit: histórico do arquivo" },
  },
}

-- nvim/lua/ericsts/plugins/todo-comments.lua
-- TODO-COMMENTS
return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {},
  keys = {
    { "<leader>ft", "<cmd>TodoTelescope<CR>",                                     desc = "Buscar TODOs" },
    { "]t",         function() require("todo-comments").jump_next() end,           desc = "Próximo TODO" },
    { "[t",         function() require("todo-comments").jump_prev() end,           desc = "TODO anterior" },
  },
}

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

-- nvim/lua/ericsts/plugins/none-ls.lua
-- NONE-LS (antigo null-ls): Formatters e Linters via LSP
-- Permite usar ferramentas como Prettier, ESLint, etc como se fossem LSP
return {
  "nvimtools/none-ls.nvim",
  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        -- === FORMATTERS ===
        null_ls.builtins.formatting.stylua,    -- Formata Lua
        null_ls.builtins.formatting.pint,     -- Formata PHP (Laravel)
        null_ls.builtins.formatting.goimports, -- Formata Go + organiza imports

        -- === LINTERS/DIAGNOSTICS ===
        -- null_ls.builtins.completion.spell, -- Spell check (desabilitado)
        -- require("none-ls.diagnostics.eslint"), -- ESLint (precisa none-ls-extras.nvim)

        -- === OUTROS ÚTEIS (comentados) ===
        -- null_ls.builtins.formatting.prettier, -- JS/TS/CSS
        -- null_ls.builtins.diagnostics.phpstan, -- PHP static analysis
      },
    })

    -- === ATALHO PARA FORMATAR ===
    -- <leader>gf: formata arquivo atual
    vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { desc = "Format file" })
  end,
}

-- nvim/lua/ericsts/plugins/which-key.lua
-- WHICH-KEY:
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {},
}

-- nvim/lua/ericsts/plugins/git.lua
-- GITSIGNS: Integração com Git (mostra mudanças, blame, etc)
-- Exibe sinais na lateral indicando linhas modificadas/adicionadas/removidas
return {
  "lewis6991/gitsigns.nvim",
  opts = {}, -- Configuração padrão
  keys = {
    -- === ATALHOS GIT ===
    -- <leader>gp: preview das mudanças (hunk)
    {
      "<leader>gp",
      ":Gitsigns preview_hunk<CR>",
      desc = "Preview Git hunk"
    },

    -- <leader>gr: desfaz mudanças (reset hunk)
    {
      "<leader>gr",
      ":Gitsigns reset_hunk<CR>",
      desc = "Reset Git hunk"
    },

    -- <leader>gb: mostra quem modificou a linha (blame)
    {
      "<leader>gb",
      ":Gitsigns blame_line<CR>",
      desc = "Git blame line"
    },

    -- <leader>gd: mostra diff do arquivo
    {
      "<leader>gd",
      ":Gitsigns diffthis<CR>",
      desc = "Git diff this"
    },
  },

  -- FEATURES AUTOMÁTICAS:
  -- - Ícones na lateral: + (adicionado), ~ (modificado), _ (removido)
  -- - [c e ]c para navegar entre mudanças
  -- - Suporta git blame inline
}

-- nvim/lua/ericsts/plugins/harpoon.lua
-- HARPOON:
return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()

    vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Harpoon: add file" })
    vim.keymap.set("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon: toggle menu" })

    vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon: file 1" })
    vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon: file 2" })
    vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon: file 3" })
    vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon: file 4" })

    vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end, { desc = "Harpoon: next file" })
    vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end, { desc = "Harpoon: prev file" })
  end
}

-- nvim/lua/ericsts/plugins/neo-tree.lua
-- NEO-TREE: Explorador de arquivos lateral (como NERDTree)
-- Mostra estrutura de pastas, git status, etc.
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons", -- Ícones bonitos
  },
  lazy = false, -- Sempre disponível
  config = function()
    require("neo-tree").setup({
      filesystem = {
        follow_current_file = { enabled = true }, -- Foca no arquivo atual
        filtered_items = {
          visible = true,       -- Mostra arquivos filtrados
          hide_dotfiles = false, -- Não esconde arquivos com .
          hide_gitignored = false, -- Mostra arquivos do .gitignore
        },
      },

      -- Fecha Neo-tree automaticamente ao abrir arquivo
      event_handlers = {
        {
          event = "file_opened",
          handler = function()
            require("neo-tree.command").execute({ action = "close" })
          end,
        },
      },

      -- === NAVEGAÇÃO TIPO VIM ===
      window = {
        mappings = {
          ["<space>"] = "toggle_node",    -- Espaço: abre/fecha pasta
          ["h"] = "navigate_up",          -- h: vai para pasta pai
          ["l"] = "open",                 -- l: abre arquivo/pasta
          ["<BS>"] = "close_node",        -- Backspace: fecha pasta
          ["<CR>"] = "open",              -- Enter: abre arquivo
        },
      },
    })

    -- === ATALHOS GLOBAIS ===
    -- Ctrl+N: toggle Neo-tree
    vim.keymap.set("n", "<C-n>", ":Neotree toggle<CR>", { desc = "Toggle Neo-tree" })

    -- <leader>e: revela arquivo atual no Neo-tree
    vim.keymap.set("n", "<leader>e", ":Neotree filesystem reveal left<CR>", { desc = "Reveal in Neo-tree" })

    -- <leader>h: toggle arquivos ocultos
    vim.keymap.set("n", "<leader>h", ":Neotree toggle_hidden<CR>", { desc = "Toggle hidden files" })
  end
}

-- vim-fugitive — git avançado: commits granulares, diff, blame, merge
return {
  "tpope/vim-fugitive",
  keys = {
    { "<leader>gG", "<cmd>Git<CR>",           desc = "Fugitive: status" },
    { "<leader>gB", "<cmd>Git blame<CR>",     desc = "Fugitive: blame (arquivo)" },
    { "<leader>gM", "<cmd>Git mergetool<CR>", desc = "Fugitive: merge tool" },
  },
}

-- nvim/lua/ericsts/plugins/trouble.lua
-- TROUBLE:
return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {},
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>",                        desc = "Trouble: diagnósticos" },
    { "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",           desc = "Trouble: buffer atual" },
    { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<CR>",                desc = "Trouble: símbolos" },
    { "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<CR>", desc = "Trouble: LSP refs/defs" },
    { "<leader>xq", "<cmd>Trouble qflist toggle<CR>",                             desc = "Trouble: quickfix" },
    {
      "]x",
      function() require("trouble").next({ skip_groups = true, jump = true }) end,
      desc = "Trouble: próximo item",
    },
    {
      "[x",
      function() require("trouble").prev({ skip_groups = true, jump = true }) end,
      desc = "Trouble: item anterior",
    },
  },
}

-- nvim/lua/ericsts/plugins/debugging.lua
-- Sistema de DEBUG (DAP - Debug Adapter Protocol)
-- Permite colocar breakpoints, inspecionar variáveis, etc.
-- NOTA: Você tem dois arquivos de debug (debugging.lua e xdebug.lua)
-- RECOMENDAÇÃO: Use apenas este arquivo e delete xdebug.lua
return {
  -- === NVIM-DAP: Debug Adapter Protocol ===
  -- Protocolo que permite debugar diversas linguagens
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",         -- Interface visual para debug
    "leoluz/nvim-dap-go",           -- Suporte para Go
    "jay-babu/mason-nvim-dap.nvim", -- Integração com Mason
    "nvim-neotest/nvim-nio",        -- Biblioteca async necessária
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    -- Configura a UI do debug
    dapui.setup()

    -- Configura Go debug
    require("dap-go").setup()

    -- === MASON-DAP: Instalador de adapters ===
    require("mason-nvim-dap").setup({
      ensure_installed = { "php", "delve" }, -- Instala adapters PHP e Go (delve)
      automatic_setup = true,
    })

    -- === EVENTOS: Abre/fecha UI automaticamente ===
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    -- === CONFIGURAÇÃO PHP XDEBUG ===
    dap.configurations.php = {
      {
        type = "php",
        request = "launch",
        name = "Xdebug",
        port = 9003, -- Porta padrão do Xdebug 3
      },
    }

    -- === ATALHOS DE DEBUG ===
    vim.keymap.set("n", "<Leader>dt", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
    vim.keymap.set("n", "<Leader>dc", dap.continue, { desc = "Continue/Start debug" })
    vim.keymap.set("n", "<Leader>dn", dap.step_over, { desc = "Step over" })
    vim.keymap.set("n", "<Leader>di", dap.step_into, { desc = "Step into" })
    vim.keymap.set("n", "<Leader>do", dap.step_out, { desc = "Step out" })
    vim.keymap.set("n", "<Leader>dr", dap.repl.open, { desc = "Open REPL" })
    vim.keymap.set("n", "<Leader>du", dapui.toggle, { desc = "Toggle debug UI" })
  end,
}

-- nvim/lua/ericsts/plugins/auto-session.lua
-- AUTO-SESSION:
return {
  "rmagatti/auto-session",
  config = function()
    local auto_session = require("auto-session")

    auto_session.setup({
      auto_restore_enabled = false,
      auto_session_suppress_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
    })

    local keymap = vim.keymap

    keymap.set("n", "<leader>wr", "<cmd>AutoSession restore<CR>", { desc = "Restore session for cwd" }) -- restore last workspace session for current directory
    keymap.set("n", "<leader>ws", "<cmd>AutoSession save<CR>", { desc = "Save session for auto session root dir" }) -- save workspace session for current working directory
  end,
}

-- plugins/autopairs.lua
return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {},
}

-- nvim/lua/ericsts/plugins/telescope.lua
-- TELESCOPE: Fuzzy finder ultra poderoso
-- Busca arquivos, texto, comandos, símbolos LSP, etc.
return {
  -- === TELESCOPE CORE ===
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' }, -- Biblioteca de funções utilitárias
    config = function()
      local builtin = require("telescope.builtin")

      -- === ATALHOS PRINCIPAIS ===
      -- Ctrl+P: Busca arquivos (como no VSCode)
      vim.keymap.set('n', '<C-p>', builtin.find_files, { desc = "Find files" })

      -- <leader>fg: Busca texto em todos os arquivos (grep)
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Live grep" })
    end
  },

  -- === TELESCOPE UI SELECT ===
  -- Substitui menus nativos do Neovim por interface do Telescope
  -- Exemplo: menu de code actions fica muito mais bonito
  {
    'nvim-telescope/telescope-ui-select.nvim',
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({
              -- Pode adicionar mais opções aqui
            })
          }
        }
      })
      require("telescope").load_extension("ui-select")
    end
  }
}

-- nvim/lua/ericsts/plugins/treesitter.lua
-- TREESITTER: Parser de código avançado
-- Fornece syntax highlighting preciso, indentação inteligente,
-- seleção de texto baseada em estrutura (text objects), etc.
return {
  "nvim-treesitter/nvim-treesitter",
  branch = 'master',
  lazy = false, -- Sempre carrega (não é lazy)
  build = ":TSUpdate", -- Atualiza parsers após instalar
  config = function()
    local config = require("nvim-treesitter.configs")
    config.setup({
      -- Linguagens que terão parsers instalados
      ensure_installed = {
        "lua", "javascript", "typescript", "php",
        "html", "css", "json", "yaml", "markdown",
        "bash", "dockerfile", "sql"
      },

      -- === FEATURES ===
      highlight = {
        enable = true, -- Ativa syntax highlighting avançado
      },
      indent = {
        enable = true, -- Ativa indentação inteligente
      },

      -- === FEATURES OPCIONAIS (você pode ativar) ===
      -- incremental_selection = {
      --   enable = true,
      --   keymaps = {
      --     init_selection = "gnn",
      --     node_incremental = "grn",
      --     scope_incremental = "grc",
      --     node_decremental = "grm",
      --   },
      -- },
    })
  end
}

-- nvim/lua/ericsts/plugins/alpha.lua
-- ALPHA: Tela inicial bonita com logo ASCII
return {
  "goolord/alpha-nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },

  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.startify")

    dashboard.section.header.val = {
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                     ]],
      [[       ████ ██████           █████      ██                     ]],
      [[      ███████████             █████                             ]],
      [[      █████████ ███████████████████ ███   ███████████   ]],
      [[     █████████  ███    █████████████ █████ ██████████████   ]],
      [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
      [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
      [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
    }

    alpha.setup(dashboard.opts)
  end,
}

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
-- nvim/lua/ericsts/vim-options.lua

vim.cmd("set expandtab")     -- Converte tabs em espaços
vim.cmd("set tabstop=2")     -- Tamanho visual de um tab = 2 espaços
vim.cmd("set softtabstop=2") -- Número de espaços ao pressionar Tab
vim.cmd("set shiftwidth=2")  -- Número de espaços para indentação automática

vim.g.mapleader = " "

vim.keymap.set("n", "<leader>ya", ":%y+<CR>", { desc = "Yank entire file" })
-- nvim/lua/ericsts/lazy.lua
-- Instala o Lazy.nvim automaticamente se não estiver instalado

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- Usa a versão estável
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Configura o Lazy para buscar plugins na pasta ericsts/plugins
require("lazy").setup(
  {
    {
      import = "ericsts.plugins" -- Importa todos os arquivos .lua de plugins/
    },
  },
  {
    rocks = {
      hererocks = false, -- Desabilita hererocks (não necessário)
      enabled = false,   -- Desabilita suporte a luarocks
    },
    checker = {
      enabled = true,  -- Verifica atualizações automaticamente
      notify = false,  -- Não mostra notificações de atualização
    },
    change_detection = {
      notify = false,  -- Não notifica sobre mudanças nos arquivos de config
    },
  }
)

  -- nvim/init.lua
require("ericsts.vim-options")
require("ericsts.lazy")
