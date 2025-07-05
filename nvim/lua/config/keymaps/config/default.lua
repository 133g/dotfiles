-- デフォルト設定
-- Neovim専用プラグインのデフォルト設定

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
  -- デフォルトではファイル保存のみ
  { key = 'w', target = ':w<CR>', opts = { desc = 'Save file' } },
}

-- ローカルリーダーキーを使ったカスタムキーマップ
M.local_leader_keymaps = {
  -- デフォルトでは空
}

-- 一括設定用のカスタムキーマップ
M.bulk_keymaps = {
  -- デフォルトでは空
}

-- ファイルタイプ固有のキーマップ
M.filetype_keymaps = {
  lua = {
    { key = 'r', target = ':luafile %<CR>', opts = { desc = 'Run current Lua file' } },
  },
}

-- 配列固有の設定
M.layout_settings = {
  default_layout = 'onishi',  -- 起動時のデフォルト配列
  enable_layout_switching = true,  -- 配列切り替え機能の有効/無効
  auto_save_layout = true,  -- 配列状態の自動保存
}


-- プラグイン設定
M.plugin_settings = {
  version = "2.0",
  enable_commands = true,  -- コマンド登録の有効/無効
  enable_autocmds = true,  -- オートコマンドの有効/無効
  debug_mode = false,  -- デバッグモード
}

-- パフォーマンス設定
M.performance_settings = {
  lazy_loading = true,  -- 遅延読み込み
  cache_layouts = true,  -- 配列定義のキャッシュ
  validation_level = "normal",  -- 設定バリデーションレベル (none/minimal/normal/strict)
}

-- 高度な設定
M.advanced_settings = {
  custom_layouts = {},  -- カスタム配列定義
  hooks = {
    before_layout_switch = nil,  -- 配列切り替え前のフック
    after_layout_switch = nil,   -- 配列切り替え後のフック
  },
  extensions = {},  -- プラグイン拡張
}

return M