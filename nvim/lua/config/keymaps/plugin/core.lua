-- キーマップシステムのコア機能
-- プラグイン化対応版 - 配列ローダーとの統合

local M = {}

-- 配列ローダーを読み込み
local layouts = require('config.keymaps.layouts')

-- 現在のレイアウト状態
local current_layout = 'onishi'

-- 論理キーから物理キーへの変換
-- @param logical_key string: 論理キー名
-- @param layout string: 配列名（省略時は現在の配列）
-- @return string|nil: 物理キー、または存在しない場合はnil
function M.resolve_logical_key(logical_key, layout)
  layout = layout or current_layout
  local logical_mapping = layouts.get_logical_mapping(layout)
  return logical_mapping[logical_key]
end

-- 利用可能な論理キー一覧を取得
-- @param layout string: 配列名（省略時は現在の配列）
-- @return table: 論理キーのリスト
function M.get_available_logical_keys(layout)
  layout = layout or current_layout
  local logical_mapping = layouts.get_logical_mapping(layout)
  
  local keys = {}
  for logical_key, _ in pairs(logical_mapping) do
    table.insert(keys, logical_key)
  end
  return keys
end

-- 利用可能な配列一覧を取得
-- @return table: 配列名のリスト
function M.get_available_layouts()
  return layouts.get_available_layouts()
end

-- 現在の配列を取得
-- @return string: 現在の配列名
function M.get_current_layout()
  return current_layout
end

-- 配列を設定
-- @param layout string: 配列名
-- @return boolean: 成功時はtrue
function M.set_current_layout(layout)
  local available_layouts = M.get_available_layouts()
  if vim.tbl_contains(available_layouts, layout) then
    current_layout = layout
    return true
  end
  return false
end

-- 配列の表示名を取得
-- @param layout string: 配列名（省略時は現在の配列）
-- @return string: 表示名
function M.get_layout_display_name(layout)
  layout = layout or current_layout
  return layouts.get_display_name(layout)
end

-- 新しい配列を登録（プラグイン拡張用）
-- @param layout_name string: 配列名
-- @param layout_def table: 配列定義
-- @return boolean: 成功時はtrue
function M.register_layout(layout_name, layout_def)
  return layouts.register_layout(layout_name, layout_def)
end

-- 配列定義を取得
-- @param layout_name string: 配列名
-- @return table|nil: 配列定義
function M.get_layout_definition(layout_name)
  return layouts.get_layout(layout_name)
end

-- 配列の互換性情報を取得
-- @param layout_name string: 配列名
-- @return table: 互換性情報
function M.get_layout_compatibility(layout_name)
  return layouts.get_compatibility_info(layout_name)
end

-- 論理キーマッピングのAPIレイヤー
M.keymap = {}

-- 基本的な論理キーマッピング
-- @param logical_key string: 論理キー名
-- @param target string: マッピング先
-- @param opts table: オプション
-- @return boolean: 成功時はtrue
function M.keymap.map(logical_key, target, opts)
  local physical_key = M.resolve_logical_key(logical_key)
  if not physical_key then
    vim.notify(
      string.format("Unknown logical key '%s' for layout '%s'", logical_key, current_layout),
      vim.log.levels.WARN
    )
    return false
  end
  
  opts = opts or {}
  local modes = opts.modes or {'n', 'v'}
  vim.keymap.set(modes, physical_key, target, opts)
  return true
end

-- モード指定可能なマッピング
-- @param modes string|table: モード
-- @param logical_key string: 論理キー名
-- @param target string: マッピング先
-- @param opts table: オプション
-- @return boolean: 成功時はtrue
function M.keymap.map_mode(modes, logical_key, target, opts)
  local physical_key = M.resolve_logical_key(logical_key)
  if not physical_key then
    vim.notify(
      string.format("Unknown logical key '%s' for layout '%s'", logical_key, current_layout),
      vim.log.levels.WARN
    )
    return false
  end
  
  vim.keymap.set(modes, physical_key, target, opts or {})
  return true
end

-- リーダーキーマッピング
-- @param key string: キー
-- @param target string: マッピング先
-- @param opts table: オプション
-- @return boolean: 成功時はtrue
function M.keymap.map_leader(key, target, opts)
  vim.keymap.set('n', '<leader>' .. key, target, opts or {})
  return true
end

-- ローカルリーダーキーマッピング
-- @param key string: キー
-- @param target string: マッピング先
-- @param opts table: オプション
-- @return boolean: 成功時はtrue
function M.keymap.map_local_leader(key, target, opts)
  vim.keymap.set('n', '<localleader>' .. key, target, opts or {})
  return true
end

-- 一括マッピング
-- @param mappings table: マッピング定義
-- @param opts table: オプション
-- @return number: 成功したマッピング数
function M.keymap.map_bulk(mappings, opts)
  local success_count = 0
  for logical_key, target in pairs(mappings) do
    if M.keymap.map(logical_key, target, opts) then
      success_count = success_count + 1
    end
  end
  return success_count
end

-- キーマップシステムの初期化
-- @param config table: 設定
-- @return boolean: 成功時はtrue
function M.init(config)
  config = config or {}
  
  -- 初期レイアウトの設定
  if config.default_layout then
    if not M.set_current_layout(config.default_layout) then
      vim.notify(
        string.format("Failed to set default layout: %s", config.default_layout),
        vim.log.levels.WARN
      )
    end
  end
  
  -- カスタムレイアウトの登録
  if config.custom_layouts then
    for layout_name, layout_def in pairs(config.custom_layouts) do
      if not M.register_layout(layout_name, layout_def) then
        vim.notify(
          string.format("Failed to register custom layout: %s", layout_name),
          vim.log.levels.WARN
        )
      end
    end
  end
  
  return true
end

-- デバッグ用情報取得
-- @return table: デバッグ情報
function M.debug_info()
  return {
    current_layout = current_layout,
    available_layouts = M.get_available_layouts(),
    available_logical_keys = M.get_available_logical_keys(),
    layout_display_name = M.get_layout_display_name(),
    layout_registry = layouts.debug_registry()
  }
end

return M