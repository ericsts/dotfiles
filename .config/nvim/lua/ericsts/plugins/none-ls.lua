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
        null_ls.builtins.formatting.stylua, -- Formata Lua
        null_ls.builtins.formatting.pint,   -- Formata PHP (Laravel)

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
