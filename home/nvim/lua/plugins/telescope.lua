return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>p", "<cmd>Telescope find_files<CR>", desc = "Find files" },
    { "<leader>f", "<cmd>Telescope live_grep<CR>",  desc = "Grep" },
    { "<leader>b", "<cmd>Telescope buffers<CR>",    desc = "Buffers" },
    { "<leader>?", "<cmd>Telescope help_tags<CR>",  desc = "Help" },
  },
}
