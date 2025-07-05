-- キーマップ配列管理システム（互換性レイヤー）
-- プラグイン化対応版 - 新しいエンジンへのブリッジ
-- 既存コードとの互換性を保つためのラッパー

local M = {}

-- 新しいプラグインエンジンの参照
local layout_engine = require('config.keymaps.plugin.layout-engine')


-- 配列の切り替え機能（互換性のためのラッパー）
local function switch_layout(layout, is_initial)
  return layout_engine.switch_layout(layout, is_initial)
end

-- トグル機能（互換性のためのラッパー）
local function toggle_layout()
  return layout_engine.toggle_layout()
end

-- 現在の配列を取得する関数（互換性のためのラッパー）
function M.get_current_layout()
  return layout_engine.get_current_layout()
end

-- 指定された配列の論理キーマッピングを取得する関数（互換性のためのラッパー）
-- @param layout string: 配列名 ('onishi', 'qwerty')
-- @param logical_key string: 論理キー名 ('up', 'down', 'left', 'right')
-- @return string|nil: 実際のキー、または存在しない場合はnil
function M.get_key_mapping(layout, logical_key)
  local keymap_api = require('config.keymaps.plugin.keymap-api')
  return keymap_api.resolve_logical_key(logical_key, layout)
end

-- 指定された配列で利用可能な論理キーの一覧を取得する関数（互換性のためのラッパー）
-- @param layout string: 配列名 ('onishi', 'qwerty')
-- @return table: 利用可能な論理キーのリスト
function M.get_available_logical_keys(layout)
  local core = require('config.keymaps.plugin.core')
  return core.get_available_logical_keys(layout)
end

-- 初期化関数（互換性のためのラッパー）
function M.init(config)
  -- 新しいエンジンに初期化を任せる（コマンド登録はメインファイルで行う）
  return layout_engine.init(config or {})
end

return M