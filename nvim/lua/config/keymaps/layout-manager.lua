-- キーマップ配列管理システム
-- 大西配列とQWERTY配列の切り替え機能を提供

local onishi = require('config.keymaps.onishi')
local qwerty = require('config.keymaps.qwerty')

local M = {}

-- ユーザー設定を読み込み
local user_config = require('config.keymaps.user-config')

-- coreモジュールの参照
local core = require('config.keymaps.core')

-- 現在の配列状態を管理
local current_layout = vim.g.keymap_layout or user_config.layout_settings.default_layout

-- coreモジュールの初期化
core.init({
  default_layout = current_layout
})

-- 配列の切り替え機能
local function switch_layout(layout, is_initial)
  -- 現在のキーマップを削除
  if current_layout == 'onishi' then
    onishi.clear()
  elseif current_layout == 'qwerty' then
    qwerty.clear()
  end
  
  -- 新しいキーマップを設定
  if layout == 'onishi' then
    onishi.setup()
    current_layout = 'onishi'
    vim.g.keymap_layout = 'onishi'
    core.set_current_layout('onishi')  -- coreモジュールの状態も更新
    if is_initial then
      print('Keymap: Onishi')
    else
      print('Keymap: Switched to Onishi')
    end
  elseif layout == 'qwerty' then
    qwerty.setup()
    current_layout = 'qwerty'
    vim.g.keymap_layout = 'qwerty'
    core.set_current_layout('qwerty')  -- coreモジュールの状態も更新
    if is_initial then
      print('Keymap: QWERTY')
    else
      print('Keymap: Switched to QWERTY')
    end
  end
  
  -- 配列切り替え後にユーザーキーマップの再適用を促すイベントを発火
  if not is_initial then
    vim.api.nvim_exec_autocmds('User', { pattern = 'KeymapLayoutChanged' })
  end
end

-- トグル機能
local function toggle_layout()
  if current_layout == 'onishi' then
    switch_layout('qwerty')
  else
    switch_layout('onishi')
  end
end

-- 現在の配列を取得する関数（外部から呼び出し用）
function M.get_current_layout()
  return current_layout
end

-- 指定された配列の論理キーマッピングを取得する関数
-- @param layout string: 配列名 ('onishi', 'qwerty')
-- @param logical_key string: 論理キー名 ('up', 'down', 'left', 'right')
-- @return string|nil: 実際のキー、または存在しない場合はnil
function M.get_key_mapping(layout, logical_key)
  -- 配列固有の論理キーマッピング定義
  local key_mappings = {
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
  
  return key_mappings[layout] and key_mappings[layout][logical_key]
end

-- 指定された配列で利用可能な論理キーの一覧を取得する関数
-- @param layout string: 配列名 ('onishi', 'qwerty')
-- @return table: 利用可能な論理キーのリスト
function M.get_available_logical_keys(layout)
  local key_mappings = {
    onishi = { 'up', 'down', 'left', 'right' },
    qwerty = { 'up', 'down', 'left', 'right' }
  }
  
  return key_mappings[layout] or {}
end

-- 初期化関数（外部から呼び出し用）
function M.init()
  -- 配列切り替え機能が有効な場合のみコマンドを登録
  if user_config.layout_settings.enable_layout_switching then
    vim.api.nvim_create_user_command('ToggleKeymap', toggle_layout, {
      desc = 'キーマップ配列を切り替え（大西配列 ⇔ QWERTY配列）'
    })

    vim.api.nvim_create_user_command('KeymapOnishi', function()
      switch_layout('onishi')
    end, {
      desc = 'キーマップを大西配列に設定'
    })

    vim.api.nvim_create_user_command('KeymapQwerty', function()
      switch_layout('qwerty')
    end, {
      desc = 'キーマップをQWERTY配列に設定'
    })

    -- 現在の配列状態を表示
    vim.api.nvim_create_user_command('KeymapStatus', function()
      print('Keymap: ' .. current_layout:upper())
    end, {
      desc = 'Show current keymap layout'
    })
  end

  -- 起動時の初期化
  switch_layout(current_layout, true)
end

return M