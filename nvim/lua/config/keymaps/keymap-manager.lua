-- キーマップ管理API
-- ユーザーが論理的なキー名でキーマップを設定するための抽象化レイヤー
-- 新しいcoreモジュールを使用したリファクタリング版

local M = {}

-- coreモジュールの参照を保持
local core = require('config.keymaps.core')

-- 論理キーでキーマップを設定する
-- @param logical_key string: 論理キー名 ('up', 'down', 'left', 'right')  
-- @param target string: マッピング先のコマンドや動作
-- @param opts table: キーマップオプション（省略可能）
function M.map(logical_key, target, opts)
  return core.keymap.map(logical_key, target, opts)
end

-- より細かい制御が必要な場合の関数
-- @param modes string|table: モード ('n', {'n', 'v'} など)
-- @param logical_key string: 論理キー名
-- @param target string: マッピング先のコマンドや動作
-- @param opts table: キーマップオプション（省略可能）
function M.map_mode(modes, logical_key, target, opts)
  return core.keymap.map_mode(modes, logical_key, target, opts)
end

-- リーダーキー付きのキーマップを設定する便利関数
-- @param key string: リーダー後のキー
-- @param target string: マッピング先のコマンドや動作  
-- @param opts table: キーマップオプション（省略可能）
function M.map_leader(key, target, opts)
  return core.keymap.map_leader(key, target, opts)
end

-- ローカルリーダーキー付きのキーマップを設定する便利関数
-- @param key string: ローカルリーダー後のキー
-- @param target string: マッピング先のコマンドや動作
-- @param opts table: キーマップオプション（省略可能）  
function M.map_local_leader(key, target, opts)
  return core.keymap.map_local_leader(key, target, opts)
end

-- 複数の論理キーマッピングを一括設定する便利関数
-- @param mappings table: {logical_key = target, ...} 形式のテーブル
-- @param opts table: 全体に適用するオプション（省略可能）
function M.map_bulk(mappings, opts)
  return core.keymap.map_bulk(mappings, opts)
end

-- 利用可能な論理キーの一覧を取得
-- @return table: 現在の配列で利用可能な論理キーのリスト
function M.get_available_keys()
  return core.get_available_logical_keys()
end

-- 現在の配列名を取得（デバッグ用）
-- @return string: 現在の配列名
function M.get_current_layout()
  return core.get_current_layout()
end

-- デバッグ用情報取得（coreモジュール経由）
-- @return table: デバッグ情報
function M.debug_info()
  return core.debug_info()
end

return M