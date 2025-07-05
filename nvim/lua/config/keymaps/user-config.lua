-- ユーザーカスタマイズ設定
-- このファイルをユーザーが直接編集してキーマップをカスタマイズします

local M = {}

-- リーダーキーの設定
M.leader_keys = {
  leader = " ",          -- メインリーダーキー
  localleader = " ",     -- ローカルリーダーキー
}

-- 基本的なカスタムキーマップ（論理キー名で定義）
M.basic_keymaps = {
  -- 論理キー名で定義（配列非依存）
  { logical_key = 'down', target = 'gj', opts = { silent = true, desc = 'Move down by display line' } },
  { logical_key = 'up', target = 'gk', opts = { silent = true, desc = 'Move up by display line' } },
}

-- リーダーキーを使ったカスタムキーマップ
M.leader_keymaps = {
  -- 例: <leader>w で保存
  { key = 'w', target = ':w<CR>', opts = { desc = 'Save file' } },
}

-- ローカルリーダーキーを使ったカスタムキーマップ
M.local_leader_keymaps = {
  -- 例: <localleader>r でファイルを実行
  -- { key = 'r', target = ':luafile %<CR>', opts = { desc = 'Run current Lua file' } },
}

-- 一括設定用のカスタムキーマップ
M.bulk_keymaps = {
  -- 複数のキーマップを一度に設定
  -- { mappings = { left = 'B', right = 'W' }, opts = { desc = 'Word navigation' } },
}

-- ファイルタイプ固有のキーマップ
M.filetype_keymaps = {
  lua = {
    { key = 'r', target = ':luafile %<CR>', opts = { desc = 'Run current Lua file' } },
  },
  -- 他のファイルタイプの設定を追加可能
}

-- 配列固有の設定（通常は変更不要）
M.layout_settings = {
  default_layout = 'onishi',  -- 起動時のデフォルト配列
  enable_layout_switching = true,  -- 配列切り替え機能の有効/無効
}

-- VSCode固有の設定
M.vscode_settings = {
  enable_vscode_integration = true,  -- VSCode統合の有効/無効
}

return M