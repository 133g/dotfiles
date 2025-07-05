-- カスタムキーバインド設定
-- ユーザーが独自に追加するキーバインドを記述するファイル

-- 配列管理システムを初期化
require('config.keymaps.layout-manager').init()

-- キーマップ管理APIを読み込み
local km = require('config.keymaps.keymap-manager')

vim.g.mapleader = " "
vim.g.maplocalleader = " "

km.map('down', 'gj', { silent = true, desc = 'Move down by display line' })
km.map('up', 'gk', { silent = true, desc = 'Move up by display line' })

