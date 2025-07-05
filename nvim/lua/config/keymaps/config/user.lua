-- ユーザーカスタマイズ設定
-- Neovim専用プラグイン版 - このファイルをユーザーが直接編集してキーマップをカスタマイズします
--
-- 📖 使い方ガイド:
--   - 基本的な使い方: keymaps/USER_GUIDE.md
--   - プラグイン設定: keymaps/PLUGIN_SETUP.md  
--   - 技術仕様: keymaps/README.md
--
-- 💡 このファイルでできること:
--   - 論理キーマッピング (up/down/left/right)
--   - リーダーキーマッピング (<leader>キー)
--   - ファイルタイプ固有のマッピング
--   - 配列切り替え設定

local M = {}

-- デフォルト設定を継承
local default = require('config.keymaps.config.default')

-- 設定を継承（必要な部分のみオーバーライド）
M = vim.tbl_deep_extend('force', default, {
  -- リーダーキーの設定（必要に応じて変更）
  leader_keys = {
    leader = " ",          -- メインリーダーキー
    localleader = " ",     -- ローカルリーダーキー
  },

  -- 基本的なカスタムキーマップ（論理キー名で定義）
  basic_keymaps = {
    -- デフォルトのgj/gkマッピングを保持
    { logical_key = 'down', target = 'gj', opts = { silent = true, desc = 'Move down by display line' } },
    { logical_key = 'up', target = 'gk', opts = { silent = true, desc = 'Move up by display line' } },
    
    -- ユーザー独自のマッピングを追加する場合はここに記述
    -- 例: { logical_key = 'left', target = 'B', opts = { desc = 'Move to previous word' } },
  },

  -- リーダーキーを使ったカスタムキーマップ
  leader_keymaps = {
    -- デフォルトのファイル保存を保持
    { key = 'w', target = ':w<CR>', opts = { desc = 'Save file' } },
    
    -- ユーザー独自のマッピングを追加する場合はここに記述
    -- 例: { key = 'q', target = ':q<CR>', opts = { desc = 'Quit' } },
  },

  -- 配列固有の設定（通常は変更不要）
  layout_settings = {
    default_layout = 'onishi',  -- 起動時のデフォルト配列
    enable_layout_switching = true,  -- 配列切り替え機能の有効/無効
    auto_save_layout = true,  -- 配列状態の自動保存
  },
})

-- ここから下は高度なカスタマイズ例（通常は変更不要）

-- ローカルリーダーキーを使ったカスタムキーマップ
-- M.local_leader_keymaps = {
--   { key = 'r', target = ':luafile %<CR>', opts = { desc = 'Run current Lua file' } },
-- }

-- 一括設定用のカスタムキーマップ
-- M.bulk_keymaps = {
--   { mappings = { left = 'B', right = 'W' }, opts = { desc = 'Word navigation' } },
-- }

-- ファイルタイプ固有のキーマップ
-- M.filetype_keymaps = {
--   lua = {
--     { key = 'r', target = ':luafile %<CR>', opts = { desc = 'Run current Lua file' } },
--     { key = 't', target = ':luafile %<CR>', opts = { desc = 'Test current Lua file' } },
--   },
--   javascript = {
--     { key = 'r', target = ':!node %<CR>', opts = { desc = 'Run with Node.js' } },
--   },
-- }

-- カスタム配列の定義例
-- M.advanced_settings = {
--   custom_layouts = {
--     dvorak = {
--       layout_name = "dvorak",
--       display_name = "Dvorak配列",
--       logical_mapping = {
--         up = ",",
--         down = "o",
--         left = "a",
--         right = "e"
--       },
--       compatibility = {
--         version = "2.0",
--         supports_vscode = true,
--         supports_neovim = true,
--         custom_logical_keys = {}
--       }
--     }
--   }
-- }

return M