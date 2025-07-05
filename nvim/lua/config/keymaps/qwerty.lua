-- ⚠️ DEPRECATED: このファイルは非推奨です
-- 新しいアーキテクチャでは layouts/qwerty.lua を使用してください
-- このファイルは互換性のために残されており、将来削除予定です

local common = require('config.keymaps.common')
local vscode = require('config.keymaps.vscode')

local M = {}

-- QWERTY配列の設定定義
local qwerty_config = {
  -- VSCode用設定
  normal = {
    ['h'] = 'left',
    ['j'] = 'down',
    ['k'] = 'up',
    ['l'] = 'right',
    ['0'] = 'start',
    ['^'] = 'firstchar',
    ['$'] = 'end',
  },
  visual = {
    ['h'] = { direction = 'left', fallback = 'h' },
    ['j'] = { direction = 'down', fallback = 'j' },
    ['k'] = { direction = 'up', fallback = 'k' },
    ['l'] = { direction = 'right', fallback = 'l' },
    ['0'] = { direction = 'start', fallback = '0' },
    ['^'] = { direction = 'firstchar', fallback = '^' },
    ['$'] = { direction = 'end', fallback = '$' },
  },
  visual_line = {
    ['h'] = 'h',
    ['j'] = 'j',
    ['k'] = 'k',
    ['l'] = 'l',
  },
  
  -- Neovim用設定（標準hjkl）
  neovim_basic = {
    ['h'] = 'h',
    ['j'] = 'j',
    ['k'] = 'k',
    ['l'] = 'l',
  },
}

-- QWERTY配列のキーマップを設定
function M.setup()
  vscode.setup_keymaps(qwerty_config)
  common.setup_neovim_keymaps(qwerty_config)
end

-- QWERTY配列のキーマップを削除
function M.clear()
  local keys = {'h', 'j', 'k', 'l', '0', '^', '$', 'H', 'J', 'K', 'L', 'n', 't', 's'}
  common.clear_keymaps(keys)
end

return M