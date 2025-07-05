-- 配列切り替えエンジン
-- プラグイン化対応版 - 配列定義と設定ロジックの分離

local M = {}

-- 依存モジュール
local core = require('config.keymaps.plugin.core')
local layouts = require('config.keymaps.layouts')
local common = require('config.keymaps.common')
local vscode = require('config.keymaps.vscode')

-- 現在の配列状態
local current_layout = nil

-- 配列固有のキーマップ設定
-- @param layout_name string: 配列名
-- @return boolean: 成功時はtrue
local function setup_layout_keymaps(layout_name)
  local layout_def = layouts.get_layout(layout_name)
  if not layout_def then
    vim.notify(
      string.format("Layout definition not found: %s", layout_name),
      vim.log.levels.ERROR
    )
    return false
  end
  
  -- VSCode用の設定
  if layout_def.vscode_config then
    vscode.setup_keymaps(layout_def)
  end
  
  -- Neovim用の設定
  if layout_def.neovim_config then
    common.setup_neovim_keymaps(layout_def.neovim_config)
  end
  
  return true
end

-- 配列固有のキーマップクリア
-- @param layout_name string: 配列名
-- @return boolean: 成功時はtrue
local function clear_layout_keymaps(layout_name)
  local layout_def = layouts.get_layout(layout_name)
  if not layout_def or not layout_def.clear_keys then
    return false
  end
  
  common.clear_keymaps(layout_def.clear_keys)
  return true
end

-- 配列の切り替え機能
-- @param layout_name string: 配列名
-- @param is_initial boolean: 初期化時の切り替えかどうか
-- @return boolean: 成功時はtrue
function M.switch_layout(layout_name, is_initial)
  -- 現在のキーマップを削除
  if current_layout then
    clear_layout_keymaps(current_layout)
  end
  
  -- 新しい配列の有効性確認
  local available_layouts = core.get_available_layouts()
  if not vim.tbl_contains(available_layouts, layout_name) then
    vim.notify(
      string.format("Unknown layout: %s", layout_name),
      vim.log.levels.ERROR
    )
    return false
  end
  
  -- 新しいキーマップを設定
  if setup_layout_keymaps(layout_name) then
    current_layout = layout_name
    vim.g.keymap_layout = layout_name
    core.set_current_layout(layout_name)
    
    -- 状態表示
    local display_name = core.get_layout_display_name(layout_name)
    if is_initial then
      print('Keymap: ' .. display_name)
    else
      print('Keymap: Switched to ' .. display_name)
    end
    
    -- 配列切り替え後のイベント発火
    if not is_initial then
      vim.api.nvim_exec_autocmds('User', { pattern = 'KeymapLayoutChanged' })
    end
    
    return true
  end
  
  return false
end

-- トグル機能
-- @return boolean: 成功時はtrue
function M.toggle_layout()
  if not current_layout then
    return false
  end
  
  -- 現在の配列に応じてトグル
  if current_layout == 'onishi' then
    return M.switch_layout('qwerty')
  elseif current_layout == 'qwerty' then
    return M.switch_layout('onishi')
  else
    -- カスタム配列の場合は、利用可能な配列の次の配列に切り替え
    local available_layouts = core.get_available_layouts()
    local current_index = nil
    
    for i, layout in ipairs(available_layouts) do
      if layout == current_layout then
        current_index = i
        break
      end
    end
    
    if current_index then
      local next_index = (current_index % #available_layouts) + 1
      return M.switch_layout(available_layouts[next_index])
    end
  end
  
  return false
end

-- 現在の配列を取得
-- @return string|nil: 現在の配列名
function M.get_current_layout()
  return current_layout
end

-- 指定された配列に直接切り替え
-- @param layout_name string: 配列名
-- @return boolean: 成功時はtrue
function M.set_layout(layout_name)
  return M.switch_layout(layout_name, false)
end

-- 配列の一覧と状態を取得
-- @return table: 配列情報
function M.get_layout_status()
  local available_layouts = core.get_available_layouts()
  local status = {
    current = current_layout,
    current_display_name = current_layout and core.get_layout_display_name(current_layout) or "None",
    available = {}
  }
  
  for _, layout_name in ipairs(available_layouts) do
    table.insert(status.available, {
      name = layout_name,
      display_name = core.get_layout_display_name(layout_name),
      is_current = layout_name == current_layout
    })
  end
  
  return status
end

-- 初期化
-- @param config table: 設定
-- @return boolean: 成功時はtrue
function M.init(config)
  config = config or {}
  
  -- デフォルト配列の設定
  local default_layout = config.default_layout or vim.g.keymap_layout or 'onishi'
  
  -- 初期配列の設定
  if M.switch_layout(default_layout, true) then
    return true
  else
    -- フォールバック：利用可能な最初の配列を使用
    local available_layouts = core.get_available_layouts()
    if #available_layouts > 0 then
      return M.switch_layout(available_layouts[1], true)
    end
  end
  
  return false
end

-- デバッグ用情報取得
-- @return table: デバッグ情報
function M.debug_info()
  return {
    current_layout = current_layout,
    layout_status = M.get_layout_status(),
    core_debug = core.debug_info()
  }
end

return M