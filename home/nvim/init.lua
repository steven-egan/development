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

vim.diagnostic.config({
  severity_sort = true,
  underline = true,
  virtual_text = { spacing = 4, source = "if_many", prefix = "●" },
  float = { border = "rounded", source = "if_many" },
})

----------------------------------------
-- Keymaps
----------------------------------------
local map = vim.keymap.set
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- window management
map("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
map("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
map("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

map("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
map("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
map("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
map("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
map("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab


----------------------------------------
-- Autocommands
----------------------------------------
-- Go source uses hard tabs by convention (gofmt enforces it on save anyway,
-- but this avoids the mismatched indentation flicker while typing).
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
  end,
})

----------------------------------------
-- Plugins (lazy.nvim)
----------------------------------------
require("config.lazy")
