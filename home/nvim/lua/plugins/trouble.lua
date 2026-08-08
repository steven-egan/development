return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = "Trouble",
  opts = { focus = true },
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics (workspace)" },
    { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Diagnostics (buffer)" },
    { "<leader>xt", "<cmd>Trouble todo toggle<CR>", desc = "Todos" },
  },
}
