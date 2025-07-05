-- キーマップシステムのメインエントリーポイント
-- プラグイン化対応版 v2.0
-- このファイルは自動生成される設定のため、直接編集しないでください
-- カスタマイズは keymaps/config/user.lua で行ってください

-- 起動時パフォーマンス最適化のため、遅延読み込みを活用
local user_config, config_errors

-- 設定の遅延初期化
local function init_user_config()
  if not user_config then
    local raw_user_config = require('config.keymaps.config.user')
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

-- 新しいプラグインアーキテクチャのAPI読み込み
local km = require('config.keymaps.plugin.keymap-api')

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
if user_config.plugin_settings.enable_autocmds then
  vim.api.nvim_create_autocmd('User', {
    pattern = 'KeymapLayoutChanged',
    callback = apply_user_keymaps,
    desc = 'Reapply user keymaps after layout change'
  })
end

-- コマンド登録（設定で有効な場合のみ）
if user_config.plugin_settings.enable_commands and user_config.layout_settings.enable_layout_switching then
  vim.api.nvim_create_user_command('ToggleKeymap', function()
    require('config.keymaps.plugin.layout-engine').toggle_layout()
  end, {
    desc = 'キーマップ配列を切り替え（大西配列 ⇔ QWERTY配列）'
  })

  vim.api.nvim_create_user_command('KeymapOnishi', function()
    require('config.keymaps.plugin.layout-engine').set_layout('onishi')
  end, {
    desc = 'キーマップを大西配列に設定'
  })

  vim.api.nvim_create_user_command('KeymapQwerty', function()
    require('config.keymaps.plugin.layout-engine').set_layout('qwerty')
  end, {
    desc = 'キーマップをQWERTY配列に設定'
  })

  vim.api.nvim_create_user_command('KeymapStatus', function()
    local engine = require('config.keymaps.plugin.layout-engine')
    local status = engine.get_layout_status()
    print('Keymap: ' .. status.current_display_name)
  end, {
    desc = 'Show current keymap layout'
  })
end

-- 新しい配列エンジンを初期化
local layout_engine = require('config.keymaps.plugin.layout-engine')
layout_engine.init(user_config.layout_settings)

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

