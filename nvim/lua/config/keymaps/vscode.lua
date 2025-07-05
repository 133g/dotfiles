local M = {}

-- ユーザー設定を読み込み
local user_config = require('config.keymaps.user-config')

-- VSCode環境の判定
M.is_vscode = vim.g.vscode ~= nil and user_config.vscode_settings.enable_vscode_integration

-- ビジュアルモード検出用のヘルパー関数
function M.get_visual_mode()
  local mode = vim.api.nvim_get_mode().mode
  if mode == 'v' then
    return 'v'  -- 文字単位のビジュアルモード
  elseif mode == 'V' then
    return 'V'  -- 行単位のビジュアルモード
  elseif mode == '\22' then
    return 'b'  -- ブロック単位のビジュアルモード
  else
    return mode -- その他のモード
  end
end

-- VSCode用のノーマルモード移動マッピング
function M.normal_move(direction)
  if not M.is_vscode then
    return nil
  end
  
  local ok, vscode = pcall(require, 'vscode-neovim')
  if not ok then
    return nil
  end
  return function()
    local cmd_args = nil
    
    if direction == 'up' then
      cmd_args = { to = 'up', by = 'wrappedLine', value = vim.v.count1 }
    elseif direction == 'down' then
      cmd_args = { to = 'down', by = 'wrappedLine', value = vim.v.count1 }
    elseif direction == 'left' then
      cmd_args = { to = 'left', by = 'character', value = vim.v.count1 }
    elseif direction == 'right' then
      cmd_args = { to = 'right', by = 'character', value = vim.v.count1 }
    elseif direction == 'start' then
      cmd_args = { to = 'wrappedLineStart' }
    elseif direction == 'firstchar' then
      cmd_args = { to = 'wrappedLineFirstNonWhitespaceCharacter' }
    elseif direction == 'end' then
      cmd_args = { to = 'wrappedLineEnd' }
    end
    
    if cmd_args then
      vscode.action('cursorMove', { args = { cmd_args } })
    end
    
    return ''
  end
end

-- VSCode用のビジュアルモード移動マッピング
function M.visual_move(direction)
  if not M.is_vscode then
    return nil
  end
  
  local ok, vscode = pcall(require, 'vscode-neovim')
  if not ok then
    return nil
  end
  return function()
    local cmd_args = nil
    
    if direction == 'up' then
      cmd_args = { to = 'up', by = 'wrappedLine', value = vim.v.count1, select = true }
    elseif direction == 'down' then
      cmd_args = { to = 'down', by = 'wrappedLine', value = vim.v.count1, select = true }
    elseif direction == 'left' then
      cmd_args = { to = 'left', by = 'character', value = vim.v.count1, select = true }
    elseif direction == 'right' then
      cmd_args = { to = 'right', by = 'character', value = vim.v.count1, select = true }
    elseif direction == 'start' then
      cmd_args = { to = 'wrappedLineStart', select = true }
    elseif direction == 'firstchar' then
      cmd_args = { to = 'wrappedLineFirstNonWhitespaceCharacter', select = true }
    elseif direction == 'end' then
      cmd_args = { to = 'wrappedLineEnd', select = true }
    end
   
    if cmd_args then
      vscode.action('cursorMove', { args = { cmd_args } })
    end
    
    return ''
  end
end

-- VSCode用のビジュアルモードマッピング生成
function M.create_visual_mapping(key, direction, fallback_key)
  if not M.is_vscode then
    return nil
  end
  
  return function()
    local mode = vim.api.nvim_get_mode().mode
    if mode == 'v' then
      return M.visual_move(direction)()
    end
    return fallback_key
  end
end

-- VSCode環境でのキーマップ設定
function M.setup_keymaps(keymap_config)
  if not M.is_vscode then
    return
  end
  
  -- ノーマルモードのマッピング
  for key, direction in pairs(keymap_config.normal) do
    vim.keymap.set('n', key, M.normal_move(direction), { expr = true, silent = true })
  end
  
  -- ビジュアルモードのマッピング
  for key, config in pairs(keymap_config.visual) do
    vim.keymap.set('v', key, M.create_visual_mapping(key, config.direction, config.fallback), { expr = true, silent = true })
  end
  
  -- ビジュアルラインモード/ブロックモードのマッピング
  if keymap_config.visual_line then
    for key, target in pairs(keymap_config.visual_line) do
      vim.keymap.set('x', key, target, { silent = true, noremap = true })
    end
  end
  
  -- 交換マッピング
  if keymap_config.swap_mappings then
    for key, target in pairs(keymap_config.swap_mappings) do
      vim.keymap.set({'n', 'v'}, key, target, { silent = true, noremap = true })
    end
  end
end

return M