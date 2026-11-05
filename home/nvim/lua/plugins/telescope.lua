return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    {
      "<leader>p",
      function()
        require("telescope.builtin").find_files({
          hidden = true,
          no_ignore = true,
          file_ignore_patterns = {
            "^%.git/",
            "^node_modules/",
            "^build/",
            "^dist/",
            "^target/",
            "^%.next/",
            "^coverage/",
          },
        })
      end,
      desc = "Find files",
    },
    { "<leader>f", "<cmd>Telescope live_grep<CR>",  desc = "Grep" },
    { "<leader>b", "<cmd>Telescope buffers<CR>",    desc = "Buffers" },
    { "<leader>?", "<cmd>Telescope help_tags<CR>",  desc = "Help" },
  },
}
