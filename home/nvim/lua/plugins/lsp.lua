return {
  -- installs and manages language server binaries
  {
    "mason-org/mason.nvim",
    config = true,
  },

  -- installs servers via Mason and auto vim.lsp.enable()s them (v2 API,
  -- Neovim 0.11+ native vim.lsp.config/vim.lsp.enable — no more `handlers`)
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      -- nixd is deliberately excluded: Mason can't install it (it has to be
      -- built with Nix), so it's on PATH via home.nix and enabled manually
      -- below instead.
      ensure_installed = {
        "lua_ls",
        "pyright",
        "gopls",
        "ts_ls",
        "bashls",
        "jsonls",
      },
    },
  },

  -- server-specific configs consumed by vim.lsp.config/vim.lsp.enable
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp", "nvim-telescope/telescope.nvim" },
    config = function()
      vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })
      vim.lsp.enable("nixd")

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local map = vim.keymap.set
          local opts = { buffer = event.buf }
          local builtin = require("telescope.builtin")
          -- Telescope's LSP pickers still jump straight to a single result;
          -- for multiple they show a fuzzy list with a live preview, instead
          -- of core's bare quickfix window (which has no preview and has to
          -- be closed by hand with :cclose).
          map("n", "gd", builtin.lsp_definitions, opts)
          map("n", "gr", builtin.lsp_references, opts)
          map("n", "K", vim.lsp.buf.hover, opts)
          map("n", "<leader>rn", vim.lsp.buf.rename, opts)
          map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          map("n", "[d", vim.diagnostic.goto_prev, opts)
          map("n", "]d", vim.diagnostic.goto_next, opts)
        end,
      })
    end,
  },
}
