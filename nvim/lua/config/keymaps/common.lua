local M = {}

-- VSCode環境の判定（VSCode Neovim拡張内かどうかを判定）
M.is_vscode = vim.g.vscode ~= nil

-- キーマップの削除用ヘルパー関数（キーマップ配列切り替え時の既存設定クリア用）
function M.clear_keymaps(keys)
  for _, key in ipairs(keys) do
    -- 基本キーマップの削除
    pcall(vim.keymap.del, 'n', key)  -- pcallでエラーを防ぎ安全に削除
    pcall(vim.keymap.del, 'v', key)
    pcall(vim.keymap.del, 'x', key)
    
    -- <C-w>キーマップの削除（ウィンドウ操作）
    pcall(vim.keymap.del, 'n', "<C-w>"..key)
    pcall(vim.keymap.del, 'v', "<C-w>"..key)
  end
end

-- 通常のNeovim環境でのキーマップ設定（VSCode環境では実行されない）
-- 新しい配列定義形式に対応
function M.setup_neovim_keymaps(layout_config)
  if M.is_vscode then
    return
  end
  
  -- 新しい形式：layout_config.neovim_config.basic
  if layout_config and layout_config.basic then
    for key, target in pairs(layout_config.basic) do
      vim.keymap.set({'n', 'v'}, key, target, { silent = true, noremap = true })
      vim.keymap.set({'n', 'v'}, "<C-w>"..key, "<C-w>"..target, { silent = true, noremap = true })
    end
  end
  
  -- 新しい形式：layout_config.neovim_config.swap
  if layout_config and layout_config.swap then
    for key, target in pairs(layout_config.swap) do
      vim.keymap.set({'n', 'v'}, key, target, { silent = true, noremap = true })
      vim.keymap.set({'n', 'v'}, "<C-w>"..key, "<C-w>"..target, { silent = true, noremap = true })
    end
  end
  
  -- 旧形式との互換性を保つ
  if layout_config and layout_config.neovim_basic then
    for key, target in pairs(layout_config.neovim_basic) do
      vim.keymap.set({'n', 'v'}, key, target, { silent = true, noremap = true })
      vim.keymap.set({'n', 'v'}, "<C-w>"..key, "<C-w>"..target, { silent = true, noremap = true })
    end
  end
  
  if layout_config and layout_config.neovim_swap then
    for key, target in pairs(layout_config.neovim_swap) do
      vim.keymap.set({'n', 'v'}, key, target, { silent = true, noremap = true })
      vim.keymap.set({'n', 'v'}, "<C-w>"..key, "<C-w>"..target, { silent = true, noremap = true })
    end
  end
end

return M
