-- Neovim config. Edit here, restart nvim — no rebuild needed.
-- Plugins live under lua/plugins/ and load via lazy.nvim (needs network on first launch).

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
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

----------------------------------------
-- Plugins (lazy.nvim)
----------------------------------------
require("config.lazy")
