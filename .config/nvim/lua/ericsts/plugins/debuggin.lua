-- lua/ericsts/plugins/debuggin.lua
return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"leoluz/nvim-dap-go",
		"jay-babu/mason-nvim-dap.nvim",
    "nvim-neotest/nvim-nio",
	},
	config = function()
		local dap, dapui = require("dap"), require("dapui")

		require("dapui").setup()
		require("dap-go").setup()

		require("mason-nvim-dap").setup({
			ensure_installed = { "php" },
			automatic_setup = true,
		})

		-- require("mason-nvim-dap").setup_handlers({})
		require("mason-nvim-dap").setup()

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

		-- PHP Xdebug config
		dap.configurations.php = {
			{
				type = "php",
				request = "launch",
				name = "Xdebug",
				port = 9003,
			},
		}

		vim.keymap.set("n", "<Leader>dt", dap.toggle_breakpoint, {})
		vim.keymap.set("n", "<Leader>dc", dap.continue, {})
    vim.keymap.set("n", "<Leader>dn", dap.step_over, {})
    vim.keymap.set("n", "<Leader>di", dap.step_into, {})
    vim.keymap.set("n", "<Leader>do", dap.step_out, {})
    vim.keymap.set("n", "<Leader>dr", dap.repl.open, {})

		vim.keymap.set("n", "<Leader>du", dapui.toggle, {})
	end,
}
