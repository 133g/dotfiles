-- 配列ローダーとレジストリ
-- 配列定義の動的読み込みと管理（プラグイン化対応）

local M = {}

-- 配列レジストリ
local layout_registry = {}

-- 標準配列の定義
local standard_layouts = {
  'onishi',
  'qwerty'
}

-- 配列定義を読み込む
-- @param layout_name string: 配列名
-- @return table|nil: 配列定義、または失敗時はnil
function M.load_layout(layout_name)
  if layout_registry[layout_name] then
    return layout_registry[layout_name]
  end
  
  local ok, layout_def = pcall(require, 'config.keymaps.layouts.' .. layout_name)
  if ok and layout_def then
    layout_registry[layout_name] = layout_def
    return layout_def
  end
  
  return nil
end

-- 配列定義を登録する（カスタム配列用）
-- @param layout_name string: 配列名
-- @param layout_def table: 配列定義
-- @return boolean: 成功時はtrue
function M.register_layout(layout_name, layout_def)
  if type(layout_name) ~= "string" or type(layout_def) ~= "table" then
    return false
  end
  
  -- 必要なフィールドの検証
  local required_fields = {'layout_name', 'logical_mapping'}
  for _, field in ipairs(required_fields) do
    if not layout_def[field] then
      vim.notify(
        string.format("Layout '%s' missing required field: %s", layout_name, field),
        vim.log.levels.ERROR
      )
      return false
    end
  end
  
  layout_registry[layout_name] = layout_def
  return true
end

-- 利用可能な配列の一覧を取得
-- @return table: 配列名のリスト
function M.get_available_layouts()
  local layouts = {}
  
  -- 標準配列の追加
  for _, layout_name in ipairs(standard_layouts) do
    local layout_def = M.load_layout(layout_name)
    if layout_def then
      table.insert(layouts, layout_name)
    end
  end
  
  -- 登録済みカスタム配列の追加
  for layout_name, _ in pairs(layout_registry) do
    if not vim.tbl_contains(layouts, layout_name) then
      table.insert(layouts, layout_name)
    end
  end
  
  return layouts
end

-- 配列定義を取得
-- @param layout_name string: 配列名
-- @return table|nil: 配列定義
function M.get_layout(layout_name)
  return M.load_layout(layout_name)
end

-- 配列の表示名を取得
-- @param layout_name string: 配列名
-- @return string: 表示名
function M.get_display_name(layout_name)
  local layout_def = M.load_layout(layout_name)
  if layout_def and layout_def.display_name then
    return layout_def.display_name
  end
  return layout_name:upper()
end

-- 配列の論理キーマッピングを取得
-- @param layout_name string: 配列名
-- @return table: 論理キーマッピング
function M.get_logical_mapping(layout_name)
  local layout_def = M.load_layout(layout_name)
  if layout_def and layout_def.logical_mapping then
    return vim.deepcopy(layout_def.logical_mapping)
  end
  return {}
end

-- 配列の互換性情報を取得
-- @param layout_name string: 配列名
-- @return table: 互換性情報
function M.get_compatibility_info(layout_name)
  local layout_def = M.load_layout(layout_name)
  if layout_def and layout_def.compatibility then
    return vim.deepcopy(layout_def.compatibility)
  end
  return {
    version = "unknown",
    supports_vscode = false,
    supports_neovim = false,
    custom_logical_keys = {}
  }
end

-- 配列レジストリをクリア（テスト用）
function M.clear_registry()
  layout_registry = {}
end

-- デバッグ用：レジストリの内容を取得
function M.debug_registry()
  return vim.deepcopy(layout_registry)
end

return M