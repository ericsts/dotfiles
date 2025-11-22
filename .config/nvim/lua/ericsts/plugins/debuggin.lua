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
      ensure_installed = { "php" }, -- Instala adapter PHP automaticamente
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
