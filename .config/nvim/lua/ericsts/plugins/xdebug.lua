-- lua/ericsts/plugins/xdebug.lua
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "leoluz/nvim-dap-go",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()

      dap.adapters.php = {
        type = "executable",
        command = "node",
        args = { "/path/to/vscode-php-debug/out/phpDebug.js" }
      }

      dap.configurations.php = {
        {
          type = "php",
          request = "launch",
          name = "Xdebug",
          port = 9003,
          stopOnEntry = false,
        },
      }

      dap.listeners.before.attach.dapui_config = function() dapui.open() end
      dap.listeners.before.launch.dapui_config = function() dapui.open() end
      dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
      dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

      -- keymaps
      vim.keymap.set("n", "<leader>dt", dap.toggle_breakpoint, {})
      vim.keymap.set("n", "<leader>dc", dap.continue, {})
      vim.keymap.set("n", "<leader>dn", dap.step_over, {})
      vim.keymap.set("n", "<leader>di", dap.step_into, {})
      vim.keymap.set("n", "<leader>do", dap.step_out, {})
      vim.keymap.set("n", "<leader>dr", dap.repl.open, {})
    end,
  },
}
