return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>lf",
      function()
        require("conform").format({ async = true, lsp_format = "fallback" })
      end,
      desc = "Format buffer",
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      nix = { "nixfmt" },
      python = { "ruff_format" },
      go = { "gofmt" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      json = { "prettier" },
      markdown = { "prettier" },
      sh = { "shfmt" },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_format = "fallback",
    },
  },
}
