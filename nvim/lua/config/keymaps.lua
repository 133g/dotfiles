-- dotfiles環境用メインエントリーポイント
-- プラグインとユーザー設定を組み合わせた使用例
--
-- プラグインとして使用する場合は、このファイルは不要です。
-- 代わりにユーザーのinit.luaで直接設定してください。

-- プラグインの初期化
local lk = require('config.keymaps.plugin')
local user_config = require('config.keymaps.config.user')

-- プラグインをセットアップ
lk.setup(user_config)

-- dotfiles環境固有のユーザーマッピングの例
-- プラグインでは、ユーザーが自分のinit.luaでこのような設定を行う

-- 論理キーマッピングの設定例
lk.map('up', 'gk', { desc = 'Move up by display line' })
lk.map('down', 'gj', { desc = 'Move down by display line' })

-- 普通のキーマップ設定
vim.g.mapleader = " "
vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = 'Save file' })

-- VSCode環境での特別な設定
local vscode = require('config.keymaps.vscode')
if vscode.is_vscode then
  -- VSCode固有のキーマップ設定
  -- ここはdotfiles環境でのみ使用される
end

-- 配列切り替え時の再適用例
vim.api.nvim_create_autocmd('User', {
  pattern = 'KeymapLayoutChanged',
  callback = function()
    -- 論理キーマッピングを再設定
    lk.map('up', 'gk', { desc = 'Move up by display line' })
    lk.map('down', 'gj', { desc = 'Move down by display line' })
  end,
  desc = 'Reapply user keymaps after layout change'
})

