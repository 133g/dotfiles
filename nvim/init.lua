require("config.lazy")

-- 基本設定
-- vim.opt.shell = "/bin/zsh"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.relativenumber = true

-- 全角文字表示設定
vim.opt.ambiwidth = 'double'

vim.opt.list = true
vim.opt.listchars = 'tab:>-', 'trail:*', 'nbsp:+'

-- クリップボードをシステムと共有
vim.opt.clipboard = 'unnamedplus'

-- VSCodeでの設定
if vim.g.vscode then
  local vscode = require('vscode-neovim')
  
  -- ビジュアルモード検出用のヘルパー関数
  local function get_visual_mode()
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
  
  -- ノーマルモード専用の移動マッピング（VSCodeのAPI使用）
  local function normal_move(direction)
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
  
  -- ビジュアルモード専用の移動マッピング（VSCodeのAPI使用）
  local function visual_move(direction)
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
  
  -- ノーマルモードのマッピング
  vim.keymap.set('n', 'n', normal_move('up'), { expr = true, silent = true })
  vim.keymap.set('n', 't', normal_move('down'), { expr = true, silent = true })
  vim.keymap.set('n', 'k', normal_move('left'), { expr = true, silent = true })
  vim.keymap.set('n', 's', normal_move('right'), { expr = true, silent = true })
  vim.keymap.set('n', '0', normal_move('start'), { expr = true, silent = true })
  vim.keymap.set('n', '^', normal_move('firstchar'), { expr = true, silent = true })
  vim.keymap.set('n', '$', normal_move('end'), { expr = true, silent = true })
    -- 文字単位のビジュアルモードのマッピング (v) - VSCodeのAPIを使用
  -- op_pendingモード以外でのみ動作するようにモード検出を追加
  vim.keymap.set('v', 'n', function()
    local mode = vim.api.nvim_get_mode().mode
    -- 通常のビジュアルモードのみ処理
    if mode == 'v' then
      return visual_move('up')()
    end
    -- その他のモード（V、^V）はxマッピングに任せる
    return 'k'
  end, { expr = true, silent = true })
  
  vim.keymap.set('v', 't', function()
    local mode = vim.api.nvim_get_mode().mode
    if mode == 'v' then
      return visual_move('down')()
    end
    return 'j'
  end, { expr = true, silent = true })
  
  vim.keymap.set('v', 'k', function()
    local mode = vim.api.nvim_get_mode().mode
    if mode == 'v' then
      return visual_move('left')()
    end
    return 'h'
  end, { expr = true, silent = true })
  
  vim.keymap.set('v', 's', function()
    local mode = vim.api.nvim_get_mode().mode
    if mode == 'v' then
      return visual_move('right')()
    end
    return 'l'
  end, { expr = true, silent = true })
  
  vim.keymap.set('v', '0', visual_move('start'), { expr = true, silent = true })
  vim.keymap.set('v', '^', visual_move('firstchar'), { expr = true, silent = true })
  vim.keymap.set('v', '$', visual_move('end'), { expr = true, silent = true })
    -- ビジュアルラインモード/ブロックモード (V,Ctrl+V) - 選択を維持するための直接マッピング
  vim.keymap.set('x', 'n', 'k', { silent = true, noremap = true })
  vim.keymap.set('x', 't', 'j', { silent = true, noremap = true })
  vim.keymap.set('x', 'k', 'h', { silent = true, noremap = true })
  vim.keymap.set('x', 's', 'l', { silent = true, noremap = true })
  
  -- h/j/l を t/n/s に置き換える
  vim.keymap.set({'n', 'v'}, 'h', 't', { silent = true, noremap = true })
  vim.keymap.set({'n', 'v'}, 'H', 'T', { silent = true, noremap = true })
  vim.keymap.set({'n', 'v'}, 'j', 'n', { silent = true, noremap = true })
  vim.keymap.set({'n', 'v'}, 'J', 'N', { silent = true, noremap = true })
  vim.keymap.set({'n', 'v'}, 'l', 's', { silent = true, noremap = true })
  vim.keymap.set({'n', 'v'}, 'L', 'S', { silent = true, noremap = true })
  
else
  -- 通常のNeovim環境での設定
  -- k = h, t = j, n = k, s = l
  vim.keymap.set({'n', 'v'}, 'k', 'h', { silent = true, noremap = true })
  vim.keymap.set({'n', 'v'}, 't', 'j', { silent = true, noremap = true })
  vim.keymap.set({'n', 'v'}, 'n', 'k', { silent = true, noremap = true })
  vim.keymap.set({'n', 'v'}, 's', 'l', { silent = true, noremap = true })

  -- 交換マッピング
  vim.keymap.set({'n', 'v'}, 'h', 't', { silent = true, noremap = true })
  vim.keymap.set({'n', 'v'}, 'H', 'T', { silent = true, noremap = true })
  vim.keymap.set({'n', 'v'}, 'j', 'n', { silent = true, noremap = true })
  vim.keymap.set({'n', 'v'}, 'J', 'N', { silent = true, noremap = true })
  vim.keymap.set({'n', 'v'}, 'l', 's', { silent = true, noremap = true })
  vim.keymap.set({'n', 'v'}, 'L', 'S', { silent = true, noremap = true })
end

-- 日本語IMEの設定
if vim.fn.executable('zenhan') == 1 then
  vim.api.nvim_create_autocmd('InsertLeave', {
    callback = function()
      vim.fn.system('zenhan 0')
    end
  })
  vim.api.nvim_create_autocmd('CmdlineLeave', {
    callback = function()
      vim.fn.system('zenhan 0')
    end
  })
end

if vim.fn.executable('im-select') == 1 then
  vim.api.nvim_create_autocmd('InsertLeave', {
    callback = function()
      vim.fn.system('im-select com.apple.keylayout.UnicodeHexInput')
    end
  })
  vim.api.nvim_create_autocmd('CmdlineLeave', {
    callback = function()
      vim.fn.system('im-select 0')
    end
  })
end


-- WSL2固有の設定
if vim.fn.has('wsl') == 1 then
  vim.g.clipboard = {
    name = 'WslClipboard',
    copy = {
      ['+'] = 'clip.exe',
      ['*'] = 'clip.exe',
    },
    paste = {
      ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
end

