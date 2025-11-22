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
