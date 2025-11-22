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
