return {
  "nvim-lualine/lualine.nvim",
  config = function()
    require("lualine").setup({
      options = { theme = "catppuccin" },
      tabline = {
        lualine_a = { "tabs" },
      },
    })
  end,
}
