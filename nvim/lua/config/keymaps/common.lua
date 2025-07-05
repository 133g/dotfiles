local M = {}

-- VSCode環境の判定（VSCode Neovim拡張内かどうかを判定）
M.is_vscode = vim.g.vscode ~= nil

-- キーマップの削除用ヘルパー関数（キーマップ配列切り替え時の既存設定クリア用）
function M.clear_keymaps(keys)
  for _, key in ipairs(keys) do
    pcall(vim.keymap.del, 'n', key)  -- pcallでエラーを防ぎ安全に削除
    pcall(vim.keymap.del, 'v', key)
    pcall(vim.keymap.del, 'x', key)
  end
end

-- 通常のNeovim環境でのキーマップ設定（VSCode環境では実行されない）
function M.setup_neovim_keymaps(keymap_config)
  if M.is_vscode then
    return
  end
  
  -- 基本マッピング
  if keymap_config.neovim_basic then
    for key, target in pairs(keymap_config.neovim_basic) do
      vim.keymap.set({'n', 'v'}, key, target, { silent = true, noremap = true })
      vim.keymap.set({'n', 'v'}, "<C-w>"..key, "<C-w>"..target, { silent = true, noremap = true })
    end
  end
  
  -- 交換マッピング
  if keymap_config.neovim_swap then
    for key, target in pairs(keymap_config.neovim_swap) do
      vim.keymap.set({'n', 'v'}, key, target, { silent = true, noremap = true })
      vim.keymap.set({'n', 'v'}, "<C-w>"..key, "<C-w>"..target, { silent = true, noremap = true })
    end
  end
end

return M
