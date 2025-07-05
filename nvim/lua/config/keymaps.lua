-- キーマップシステムのメインエントリーポイント
-- このファイルは自動生成される設定のため、直接編集しないでください
-- カスタマイズは keymaps/user-config.lua で行ってください

-- 起動時パフォーマンス最適化のため、遅延読み込みを活用
local user_config, config_errors

-- 設定の遅延初期化
local function init_user_config()
  if not user_config then
    local raw_user_config = require('config.keymaps.user-config')
    local config_schema = require('config.keymaps.config-schema')
    user_config, config_errors = config_schema.sanitize_config(raw_user_config)
    
    -- バリデーションエラーがある場合は警告を表示（エラーでも動作は継続）
    if #config_errors > 0 then
      vim.notify("Keymap configuration has some issues, but continuing with defaults", vim.log.levels.WARN)
    end
  end
  return user_config
end

-- 初期化を実行
user_config = init_user_config()

-- リーダーキーの設定
vim.g.mapleader = user_config.leader_keys.leader
vim.g.maplocalleader = user_config.leader_keys.localleader

-- キーマップ管理APIを読み込み
local km = require('config.keymaps.keymap-manager')

-- ユーザー設定のキーマップを適用する関数
local function apply_user_keymaps()
  -- 基本的なカスタムキーマップを適用
  for _, keymap in ipairs(user_config.basic_keymaps) do
    km.map(keymap.logical_key, keymap.target, keymap.opts)
  end

  -- リーダーキーマップを適用
  for _, keymap in ipairs(user_config.leader_keymaps) do
    km.map_leader(keymap.key, keymap.target, keymap.opts)
  end

  -- ローカルリーダーキーマップを適用
  for _, keymap in ipairs(user_config.local_leader_keymaps) do
    km.map_local_leader(keymap.key, keymap.target, keymap.opts)
  end

  -- 一括キーマップを適用
  for _, bulk in ipairs(user_config.bulk_keymaps) do
    km.map_bulk(bulk.mappings, bulk.opts)
  end
end

-- 配列切り替え後にユーザーキーマップを再適用するためのオートコマンド
vim.api.nvim_create_autocmd('User', {
  pattern = 'KeymapLayoutChanged',
  callback = apply_user_keymaps,
  desc = 'Reapply user keymaps after layout change'
})

-- 配列管理システムを初期化
require('config.keymaps.layout-manager').init()

-- 初回のユーザーキーマップ適用
apply_user_keymaps()

-- ファイルタイプ固有のキーマップを設定
for filetype, keymaps in pairs(user_config.filetype_keymaps) do
  vim.api.nvim_create_autocmd('FileType', {
    pattern = filetype,
    callback = function()
      for _, keymap in ipairs(keymaps) do
        km.map_local_leader(keymap.key, keymap.target, 
          vim.tbl_extend('force', keymap.opts or {}, { buffer = true }))
      end
    end,
  })
end

