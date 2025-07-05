-- QWERTY配列の定義
-- Neovim専用の論理キーマッピング定義

local M = {}

-- QWERTY配列の基本情報
M.layout_name = "qwerty"
M.display_name = "QWERTY配列"

-- 論理キーから物理キーへのマッピング
M.logical_mapping = {
  up = 'k',
  down = 'j',
  left = 'h',
  right = 'l'
}

-- 物理キーマッピング（標準hjkl）
M.key_mappings = {
  basic = {
    ['h'] = 'h',
    ['j'] = 'j',
    ['k'] = 'k',
    ['l'] = 'l',
  }
}

-- クリア対象のキー一覧
M.clear_keys = {'h', 'j', 'k', 'l', 'H', 'J', 'K', 'L', 'n', 't', 's'}

-- メタデータ
M.metadata = {
  version = "2.0",
  description = "QWERTY配列用のキーマッピング定義（標準）",
  custom_logical_keys = {}
}

return M