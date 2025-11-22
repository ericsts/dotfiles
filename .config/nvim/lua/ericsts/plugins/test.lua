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
