return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main", -- full rewrite; "master" is locked to Nvim 0.11 compat and
  -- breaks on newer core treesitter internals (crashes like conceal_line
  -- "attempt to call method 'range' (a nil value)" during hover/highlight)
  lazy = false, -- this branch doesn't support lazy-loading
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").install({
      "lua", "nix", "python", "go", "typescript", "tsx", "markdown", "bash", "json", "toml",
    })

    -- Highlighting/indent are no longer enabled by a `setup()` table on this
    -- branch — start them explicitly per buffer.
    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        pcall(vim.treesitter.start)
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
