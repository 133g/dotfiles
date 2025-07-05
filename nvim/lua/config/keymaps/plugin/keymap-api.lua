-- キーマッピングAPI
-- プラグイン化対応版 - ユーザー向けのシンプルなAPI

local M = {}

-- 依存モジュール
local core = require('config.keymaps.plugin.core')

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

-- 条件付きキーマップ設定（便利関数）
-- @param condition function: 条件判定関数
-- @param logical_key string: 論理キー名
-- @param target string: マッピング先
-- @param opts table: オプション
-- @return boolean: 成功時はtrue
function M.map_conditional(condition, logical_key, target, opts)
  if type(condition) == "function" and condition() then
    return M.map(logical_key, target, opts)
  end
  return false
end

-- ファイルタイプ固有のキーマップ設定（便利関数）
-- @param filetype string: ファイルタイプ
-- @param logical_key string: 論理キー名
-- @param target string: マッピング先
-- @param opts table: オプション
function M.map_filetype(filetype, logical_key, target, opts)
  vim.api.nvim_create_autocmd('FileType', {
    pattern = filetype,
    callback = function()
      opts = opts or {}
      opts.buffer = true
      M.map(logical_key, target, opts)
    end,
  })
end

-- バッファ固有のキーマップ設定（便利関数）
-- @param logical_key string: 論理キー名
-- @param target string: マッピング先
-- @param opts table: オプション
function M.map_buffer(logical_key, target, opts)
  opts = opts or {}
  opts.buffer = true
  return M.map(logical_key, target, opts)
end

-- 利用可能な論理キーの一覧を取得
-- @return table: 現在の配列で利用可能な論理キーのリスト
function M.get_available_keys()
  return core.get_available_logical_keys()
end

-- 現在の配列名を取得
-- @return string: 現在の配列名
function M.get_current_layout()
  return core.get_current_layout()
end

-- 配列の表示名を取得
-- @param layout_name string: 配列名（省略時は現在の配列）
-- @return string: 表示名
function M.get_layout_display_name(layout_name)
  return core.get_layout_display_name(layout_name)
end

-- 利用可能な配列の一覧を取得
-- @return table: 配列名のリスト
function M.get_available_layouts()
  return core.get_available_layouts()
end

-- 論理キーの物理キーを取得（デバッグ用）
-- @param logical_key string: 論理キー名
-- @param layout_name string: 配列名（省略時は現在の配列）
-- @return string|nil: 物理キー
function M.resolve_logical_key(logical_key, layout_name)
  return core.resolve_logical_key(logical_key, layout_name)
end

-- カスタム配列を登録
-- @param layout_name string: 配列名
-- @param layout_def table: 配列定義
-- @return boolean: 成功時はtrue
function M.register_layout(layout_name, layout_def)
  return core.register_layout(layout_name, layout_def)
end

-- デバッグ用情報取得
-- @return table: デバッグ情報
function M.debug_info()
  return core.debug_info()
end

-- API情報の取得（プラグイン情報用）
-- @return table: API情報
function M.get_api_info()
  return {
    version = "2.0",
    api_functions = {
      "map", "map_mode", "map_leader", "map_local_leader", "map_bulk",
      "map_conditional", "map_filetype", "map_buffer",
      "get_available_keys", "get_current_layout", "get_layout_display_name",
      "get_available_layouts", "resolve_logical_key", "register_layout"
    },
    supported_logical_keys = M.get_available_keys(),
    current_layout = M.get_current_layout()
  }
end

return M