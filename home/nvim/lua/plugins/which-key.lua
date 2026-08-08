return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    -- Only prefixes with more than one sub-binding get a group label here —
    -- single-leaf leader keys (e.g. <leader>ca, <leader>rn) show their own
    -- `desc` in the popup without needing one.
    spec = {
      { "<leader>h", group = "git hunk" },
      { "<leader>x", group = "diagnostics/trouble" },
      { "<leader>s", group = "split" },
      { "<leader>t", group = "tab" },
    },
  },
}
