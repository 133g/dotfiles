vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.lazy")

vim.cmd.colorscheme("catppuccin")

-- Basic
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8
vim.opt.termguicolors = true
vim.opt.encoding = "utf-8"
vim.opt.clipboard = "unnamedplus"

-- Indentation
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

-- keymap for onishi

-- local USE_LAYOUT = ''
local USE_LAYOUT = "onishi"

if USE_LAYOUT == "" then
  vim.keymap.set({ "n", "v", "o" }, "j", "gj", { noremap = true, silent = true })
  vim.keymap.set({ "n", "v", "o" }, "k", "gk", { noremap = true, silent = true })

  vim.keymap.set("n", "<leader>h", "<C-w>h", { noremap = true, silent = true })
  vim.keymap.set("n", "<leader>j", "<C-w>j", { noremap = true, silent = true })
  vim.keymap.set("n", "<leader>k", "<C-w>k", { noremap = true, silent = true })
  vim.keymap.set("n", "<leader>l", "<C-w>l", { noremap = true, silent = true })

  vim.keymap.set("n", "<leader>s", ":split<CR>", { noremap = true, silent = true })
end

if USE_LAYOUT == "onishi" then
  vim.keymap.set({ "n", "v", "o" }, "k", "h", { noremap = true, silent = true })
  vim.keymap.set({ "n", "v", "o" }, "t", "gj", { noremap = true, silent = true })
  vim.keymap.set({ "n", "v", "o" }, "n", "gk", { noremap = true, silent = true })
  vim.keymap.set({ "n", "v", "o" }, "s", "l", { noremap = true, silent = true })

  vim.keymap.set({ "n", "v", "o" }, "j", "n", { noremap = true, silent = true })
  vim.keymap.set({ "n", "v", "o" }, "l", "s", { noremap = true, silent = true })
  vim.keymap.set({ "n", "v", "o" }, "h", "t", { noremap = true, silent = true })

  vim.keymap.set("n", "<leader>t", "<C-w>j", { noremap = true, silent = true })
  vim.keymap.set("n", "<leader>n", "<C-w>k", { noremap = true, silent = true })
  vim.keymap.set("n", "<leader>s", "<C-w>l", { noremap = true, silent = true })
  vim.keymap.set("n", "<leader>k", "<C-w>h", { noremap = true, silent = true })

  vim.keymap.set("n", "<leader>l", ":split<CR>", { noremap = true, silent = true })
end

vim.keymap.set("n", "<leader>v", ":vsplit<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>c", ":close<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit" })

vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next Buffer" })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous Buffer" })

vim.keymap.set("n", "Y", "y$", { noremap = true, silent = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "x", '"_x', { noremap = true, silent = true })

require("config.ime")
require("config.wsl")
