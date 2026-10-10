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
        "yaml-language-server",
        "helm-ls",
      },
    },
  },

  -- server-specific configs consumed by vim.lsp.config/vim.lsp.enable
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp", "nvim-telescope/telescope.nvim" },
    config = function()
      vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })

      -- YAML: k8s JSON schema applied to k8s-looking manifests, SchemaStore
      -- covers everything else (docker-compose, GH Actions, etc.)
      vim.lsp.config("yaml_ls", {
        settings = {
          yaml = {
            schemaStore = { enable = true },
            validate = true,
            schemas = {
              ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.34.11-standalone-strict/all.json"] = {
                "*.k8s.yaml",
                "*.k8s.yml",
                "**/k8s/**/*.yaml",
                "**/k8s/**/*.yml",
                "**/manifests/**/*.yaml",
                "**/manifests/**/*.yml",
                "*deployment.yaml",
                "*service.yaml",
                "*configmap.yaml",
                "*secret.yaml",
                "*ingress.yaml",
                "*statefulset.yaml",
                "*daemonset.yaml",
                "*cronjob.yaml",
                "*job.yaml",
                "*pod.yaml",
                "*hpa.yaml",
                "*pv.yaml",
                "*pvc.yaml",
                "*namespace.yaml",
              },
            },
          },
        },
      })

      -- Helm: autocompletion in templates/ and values files. helm-ls delegates
      -- YAML duties to the yaml-language-server installed by Mason (using its
      -- bundled k8s schema for rendered manifests).
      vim.lsp.config("helm_ls", {
        settings = {
          ["helm-ls"] = {
            yamlls = {
              path = vim.fn.stdpath("data") .. "/mason/bin/yaml-language-server",
              enabled = true,
              config = {
                schemas = {
                  kubernetes = "templates/**",
                },
                completion = true,
                hover = true,
              },
            },
          },
        },
      })

      vim.lsp.enable("nixd")
      vim.lsp.enable("yaml_ls")
      vim.lsp.enable("helm_ls")

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
