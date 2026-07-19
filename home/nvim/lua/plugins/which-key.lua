return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    spec = {
      { "<leader>f", group = "find" },
      { "<leader>g", group = "git/grep" },
      { "<leader>c", group = "code" },
      { "<leader>r", group = "rename" },
    },
  },
}
