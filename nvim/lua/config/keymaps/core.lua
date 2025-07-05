-- ⚠️ DEPRECATED: このファイルは非推奨です
-- 新しいアーキテクチャでは plugin/core.lua を使用してください
-- このファイルは互換性のために残されており、将来削除予定です
--
-- キーマップシステムのコア機能
-- プラグイン化時に独立したモジュールとして提供される機能

local M = {}

-- 配列マッピングの定義（将来的にはプラグイン設定で拡張可能）
local layout_mappings = {
  onishi = {
    up = 'n',
    down = 't', 
    left = 'k',
    right = 's'
  },
  qwerty = {
    up = 'k',
    down = 'j',
    left = 'h', 
    right = 'l'
  }
}

-- 現在のレイアウト状態
local current_layout = 'onishi'

-- 論理キーから物理キーへの変換
function M.resolve_logical_key(logical_key, layout)
  layout = layout or current_layout
  local mapping = layout_mappings[layout]
  return mapping and mapping[logical_key]
end

-- 利用可能な論理キー一覧を取得
function M.get_available_logical_keys(layout)
  layout = layout or current_layout
  local mapping = layout_mappings[layout]
  if not mapping then
    return {}
  end
  
  local keys = {}
  for logical_key, _ in pairs(mapping) do
    table.insert(keys, logical_key)
  end
  return keys
end

-- 利用可能な配列一覧を取得
function M.get_available_layouts()
  local layouts = {}
  for layout, _ in pairs(layout_mappings) do
    table.insert(layouts, layout)
  end
  return layouts
end

-- 現在の配列を取得
function M.get_current_layout()
  return current_layout
end

-- 配列を設定
function M.set_current_layout(layout)
  if layout_mappings[layout] then
    current_layout = layout
    return true
  end
  return false
end

-- 新しい配列マッピングを追加（プラグイン拡張用）
function M.add_layout_mapping(layout_name, mapping)
  if type(layout_name) ~= "string" or type(mapping) ~= "table" then
    return false
  end
  
  layout_mappings[layout_name] = mapping
  return true
end

-- 配列マッピングを取得（デバッグ用）
function M.get_layout_mapping(layout)
  layout = layout or current_layout
  return layout_mappings[layout] and vim.deepcopy(layout_mappings[layout])
end

-- 論理キーマッピングのAPIレイヤー
M.keymap = {}

-- 基本的な論理キーマッピング
function M.keymap.map(logical_key, target, opts)
  local physical_key = M.resolve_logical_key(logical_key)
  if not physical_key then
    vim.notify(
      string.format("Unknown logical key '%s' for layout '%s'", logical_key, current_layout),
      vim.log.levels.WARN
    )
    return false
  end
  
  local modes = opts and opts.modes or {'n', 'v'}
  vim.keymap.set(modes, physical_key, target, opts)
  return true
end

-- モード指定可能なマッピング
function M.keymap.map_mode(modes, logical_key, target, opts)
  local physical_key = M.resolve_logical_key(logical_key)
  if not physical_key then
    vim.notify(
      string.format("Unknown logical key '%s' for layout '%s'", logical_key, current_layout),
      vim.log.levels.WARN
    )
    return false
  end
  
  vim.keymap.set(modes, physical_key, target, opts)
  return true
end

-- リーダーキーマッピング
function M.keymap.map_leader(key, target, opts)
  vim.keymap.set('n', '<leader>' .. key, target, opts)
  return true
end

-- ローカルリーダーキーマッピング
function M.keymap.map_local_leader(key, target, opts)
  vim.keymap.set('n', '<localleader>' .. key, target, opts)
  return true
end

-- 一括マッピング
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
function M.init(config)
  config = config or {}
  
  -- 初期レイアウトの設定
  if config.default_layout then
    M.set_current_layout(config.default_layout)
  end
  
  -- カスタムレイアウトマッピングの追加
  if config.custom_layouts then
    for layout_name, mapping in pairs(config.custom_layouts) do
      M.add_layout_mapping(layout_name, mapping)
    end
  end
end

-- デバッグ用情報取得
function M.debug_info()
  return {
    current_layout = current_layout,
    available_layouts = M.get_available_layouts(),
    available_logical_keys = M.get_available_logical_keys(),
    layout_mappings = vim.deepcopy(layout_mappings)
  }
end

return M