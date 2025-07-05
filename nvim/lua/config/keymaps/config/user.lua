-- ユーザー設定ファイル (dotfiles環境専用)
-- プラグインとしての使用時は、ユーザーが自分のinit.luaで設定してください
--
-- このファイルは、dotfiles環境でプラグインとユーザー設定を組み合わせて使用する場合の例です

local M = {}

-- デフォルト設定を継承
local default = require('config.keymaps.config.default')

-- 設定を継承（必要な部分のみオーバーライド）
M = vim.tbl_deep_extend('force', default, {
  -- 配列固有の設定
  default_layout = 'onishi',  -- 起動時のデフォルト配列
  enable_layout_switching = true,  -- 配列切り替え機能の有効/無効
  enable_commands = true,  -- コマンド登録の有効/無効
})

return M