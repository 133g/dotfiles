-- キーマップ管理API
-- ユーザーが論理的なキー名でキーマップを設定するための抽象化レイヤー

local M = {}

-- layout-managerの参照を保持
local layout_manager = require('config.keymaps.layout-manager')

-- 論理キーから実際のキーへのマッピングを取得
local function get_actual_key(logical_key)
  local current_layout = layout_manager.get_current_layout()
  return layout_manager.get_key_mapping(current_layout, logical_key)
end

-- 論理キーでキーマップを設定する
-- @param logical_key string: 論理キー名 ('up', 'down', 'left', 'right')  
-- @param target string: マッピング先のコマンドや動作
-- @param opts table: キーマップオプション（省略可能）
function M.map(logical_key, target, opts)
  local actual_key = get_actual_key(logical_key)
  
  if actual_key then
    -- ユーザーが完全にコントロール、Vimの標準に従う
    local modes = {'n', 'v'} -- デフォルトモード（ユーザーがmodeオプションで上書き可能）
    local final_opts = opts or {}
    
    vim.keymap.set(modes, actual_key, target, final_opts)
  else
    vim.notify(
      string.format("Warning: Unknown logical key '%s' for layout '%s'", 
        logical_key, layout_manager.get_current_layout()),
      vim.log.levels.WARN
    )
  end
end

-- より細かい制御が必要な場合の関数
-- @param modes string|table: モード ('n', {'n', 'v'} など)
-- @param logical_key string: 論理キー名
-- @param target string: マッピング先のコマンドや動作
-- @param opts table: キーマップオプション（省略可能）
function M.map_mode(modes, logical_key, target, opts)
  local actual_key = get_actual_key(logical_key)
  
  if actual_key then
    vim.keymap.set(modes, actual_key, target, opts or {})
  else
    vim.notify(
      string.format("Warning: Unknown logical key '%s' for layout '%s'", 
        logical_key, layout_manager.get_current_layout()),
      vim.log.levels.WARN
    )
  end
end

-- リーダーキー付きのキーマップを設定する便利関数
-- @param key string: リーダー後のキー
-- @param target string: マッピング先のコマンドや動作  
-- @param opts table: キーマップオプション（省略可能）
function M.map_leader(key, target, opts)
  vim.keymap.set('n', '<leader>' .. key, target, opts or {})
end

-- ローカルリーダーキー付きのキーマップを設定する便利関数
-- @param key string: ローカルリーダー後のキー
-- @param target string: マッピング先のコマンドや動作
-- @param opts table: キーマップオプション（省略可能）  
function M.map_local_leader(key, target, opts)
  vim.keymap.set('n', '<localleader>' .. key, target, opts or {})
end

-- 複数の論理キーマッピングを一括設定する便利関数
-- @param mappings table: {logical_key = target, ...} 形式のテーブル
-- @param opts table: 全体に適用するオプション（省略可能）
function M.map_bulk(mappings, opts)
  for logical_key, target in pairs(mappings) do
    M.map(logical_key, target, opts)
  end
end

-- 利用可能な論理キーの一覧を取得
-- @return table: 現在の配列で利用可能な論理キーのリスト
function M.get_available_keys()
  local current_layout = layout_manager.get_current_layout()
  return layout_manager.get_available_logical_keys(current_layout)
end

-- 現在の配列名を取得（デバッグ用）
-- @return string: 現在の配列名
function M.get_current_layout()
  return layout_manager.get_current_layout()
end

return M