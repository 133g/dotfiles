-- QWERTY配列の定義
-- 純粋な配列定義のみを含む（プラグイン化対応）

local M = {}

-- QWERTY配列の基本マッピング定義
M.layout_name = "qwerty"
M.display_name = "QWERTY配列"

-- 論理キーから物理キーへのマッピング
M.logical_mapping = {
  up = 'k',
  down = 'j',
  left = 'h',
  right = 'l'
}

-- VSCode用の詳細設定
M.vscode_config = {
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
  }
}

-- Neovim用の基本設定（標準hjkl）
M.neovim_config = {
  basic = {
    ['h'] = 'h',
    ['j'] = 'j',
    ['k'] = 'k',
    ['l'] = 'l',
  }
}

-- クリア対象のキー一覧
M.clear_keys = {'h', 'j', 'k', 'l', '0', '^', '$', 'H', 'J', 'K', 'L', 'n', 't', 's'}

-- 配列の互換性情報
M.compatibility = {
  version = "2.0",
  supports_vscode = true,
  supports_neovim = true,
  custom_logical_keys = {}
}

return M