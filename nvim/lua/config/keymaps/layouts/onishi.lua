-- 大西配列の定義
-- 純粋な配列定義のみを含む（プラグイン化対応）

local M = {}

-- 大西配列の基本マッピング定義
M.layout_name = "onishi"
M.display_name = "大西配列"

-- 論理キーから物理キーへのマッピング
M.logical_mapping = {
  up = 'n',
  down = 't',
  left = 'k',
  right = 's'
}

-- VSCode用の詳細設定
M.vscode_config = {
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
  }
}

-- Neovim用の基本設定
M.neovim_config = {
  basic = {
    ['k'] = 'h',
    ['t'] = 'j',
    ['n'] = 'k',
    ['s'] = 'l',
  },
  swap = {
    ['h'] = 't',
    ['H'] = 'T',
    ['j'] = 'n',
    ['J'] = 'N',
    ['l'] = 's',
    ['L'] = 'S',
  }
}

-- クリア対象のキー一覧
M.clear_keys = {'n', 't', 'k', 's', '0', '^', '$', 'h', 'H', 'j', 'J', 'l', 'L'}

-- 配列の互換性情報
M.compatibility = {
  version = "2.0",
  supports_vscode = true,
  supports_neovim = true,
  custom_logical_keys = {}
}

return M