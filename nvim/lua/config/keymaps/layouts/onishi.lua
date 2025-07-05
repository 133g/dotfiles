-- 大西配列の定義
-- Neovim専用の論理キーマッピング定義

local M = {}

-- 大西配列の基本情報
M.layout_name = "onishi"
M.display_name = "大西配列"

-- 論理キーから物理キーへのマッピング
M.logical_mapping = {
  up = 'n',
  down = 't',
  left = 'k',
  right = 's'
}

-- 物理キーマッピング（移動キーの入れ替え）
M.key_mappings = {
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
M.clear_keys = {'n', 't', 'k', 's', 'h', 'H', 'j', 'J', 'l', 'L'}

-- メタデータ
M.metadata = {
  version = "2.0",
  description = "大西配列用のキーマッピング定義",
  custom_logical_keys = {}
}

return M