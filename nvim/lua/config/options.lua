-- 基本設定
-- vim.opt.shell = "/bin/zsh"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true

-- 全角文字表示設定
vim.opt.ambiwidth = 'double'

vim.opt.list = true
vim.opt.listchars = 'tab:>-', 'trail:*', 'nbsp:+'

-- クリップボードをシステムと共有
vim.opt.clipboard = 'unnamedplus'

-- xで削除するときレジスタへの保存を回避
vim.api.nvim_set_keymap("n", "x", '"_x', { noremap = true, silent = true })
