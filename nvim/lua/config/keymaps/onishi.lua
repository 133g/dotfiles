local common = require('config.keymaps.common')
local vscode = require('config.keymaps.vscode')

local M = {}

-- 大西配列の設定定義
local onishi_config = {
  -- VSCode用設定
  normal = {
    ['n'] = 'up',
    ['t'] = 'down',
    ['k'] = 'left',
    ['s'] = 'right',
    ['0'] = 'start',
    ['^'] = 'firstchar',
    ['$'] = 'end',
  },
  visual = {
    ['n'] = { direction = 'up', fallback = 'k' },
    ['t'] = { direction = 'down', fallback = 'j' },
    ['k'] = { direction = 'left', fallback = 'h' },
    ['s'] = { direction = 'right', fallback = 'l' },
    ['0'] = { direction = 'start', fallback = '0' },
    ['^'] = { direction = 'firstchar', fallback = '^' },
    ['$'] = { direction = 'end', fallback = '$' },
  },
  visual_line = {
    ['n'] = 'k',
    ['t'] = 'j',
    ['k'] = 'h',
    ['s'] = 'l',
  },
  swap_mappings = {
    ['h'] = 't',
    ['H'] = 'T',
    ['j'] = 'n',
    ['J'] = 'N',
    ['l'] = 's',
    ['L'] = 'S',
  },
  
  -- Neovim用設定
  neovim_basic = {
    ['k'] = 'h',
    ['t'] = 'j',
    ['n'] = 'k',
    ['s'] = 'l',
  },
  neovim_swap = {
    ['h'] = 't',
    ['H'] = 'T',
    ['j'] = 'n',
    ['J'] = 'N',
    ['l'] = 's',
    ['L'] = 'S',
  },
}

-- 大西配列のキーマップを設定
function M.setup()
  vscode.setup_keymaps(onishi_config)
  common.setup_neovim_keymaps(onishi_config)
end

-- 大西配列のキーマップを削除
function M.clear()
  local keys = {'n', 't', 'k', 's', '0', '^', '$', 'h', 'H', 'j', 'J', 'l', 'L'}
  common.clear_keymaps(keys)
end

return M