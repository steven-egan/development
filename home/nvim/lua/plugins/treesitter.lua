return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master", -- legacy branch; stable setup API
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "lua", "nix", "python", "go", "typescript", "tsx", "markdown", "bash", "json", "toml" },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}
