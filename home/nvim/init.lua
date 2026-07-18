-- Minimal Neovim config. Edit here, restart nvim — no rebuild needed.
-- Plugins bootstrap via lazy.nvim on first launch (needs network once).

----------------------------------------
-- Options
----------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.clipboard = "unnamedplus" -- share system clipboard
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.updatetime = 250

----------------------------------------
-- Keymaps
----------------------------------------
local map = vim.keymap.set
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
map("n", "<leader>e", "<cmd>Explore<CR>", { desc = "File explorer" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

----------------------------------------
-- Bootstrap lazy.nvim
----------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

----------------------------------------
-- Plugins
----------------------------------------
require("lazy").setup({
  -- colorscheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },

  -- fuzzy finding
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>f", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>g", "<cmd>Telescope live_grep<CR>",  desc = "Grep" },
      { "<leader>b", "<cmd>Telescope buffers<CR>",    desc = "Buffers" },
      { "<leader>?", "<cmd>Telescope help_tags<CR>",  desc = "Help" },
    },
  },

  -- syntax highlighting
  {
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
  },

  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({ options = { theme = "catppuccin" } })
    end,
  },

  -- git signs in the gutter
  { "lewis6991/gitsigns.nvim", config = true },
})
