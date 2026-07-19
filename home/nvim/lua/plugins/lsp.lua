return {
  -- installs and manages language server binaries
  {
    "mason-org/mason.nvim",
    config = true,
  },

  -- bridges mason-installed servers to lspconfig
  { "mason-org/mason-lspconfig.nvim", dependencies = { "mason-org/mason.nvim" } },

  -- LSP client configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local map = vim.keymap.set
          local opts = { buffer = event.buf }
          map("n", "gd", vim.lsp.buf.definition, opts)
          map("n", "gr", vim.lsp.buf.references, opts)
          map("n", "K", vim.lsp.buf.hover, opts)
          map("n", "<leader>rn", vim.lsp.buf.rename, opts)
          map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          map("n", "[d", vim.diagnostic.goto_prev, opts)
          map("n", "]d", vim.diagnostic.goto_next, opts)
        end,
      })

      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "nixd",
          "pyright",
          "gopls",
          "ts_ls",
          "bashls",
          "jsonls",
        },
        handlers = {
          function(server_name)
            require("lspconfig")[server_name].setup({ capabilities = capabilities })
          end,
        },
      })
    end,
  },
}
