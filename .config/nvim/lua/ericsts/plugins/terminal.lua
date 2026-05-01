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
