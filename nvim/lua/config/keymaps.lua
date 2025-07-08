-- Neovim キーマップ設定
-- 大西配列とQWERTY配列の設定

-- 設定: 使用するキーボード配列を選択
-- 'onishi' または 'qwerty' を設定
local USE_LAYOUT = 'onishi'

-- リーダーキーを設定
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 大西配列の設定
if USE_LAYOUT == 'onishi' then
  -- 移動キーの再マップ (k=左, t=下, n=上, s=右)
  vim.keymap.set({'n', 'v', 'o'}, 'k', 'h', { noremap = true, silent = true })
  vim.keymap.set({'n', 'v', 'o'}, 't', 'j', { noremap = true, silent = true })
  vim.keymap.set({'n', 'v', 'o'}, 'n', 'k', { noremap = true, silent = true })
  vim.keymap.set({'n', 'v', 'o'}, 's', 'l', { noremap = true, silent = true })
  
  -- 検索・置換で使う元のキーを別の場所に移動
  vim.keymap.set({'n', 'v', 'o'}, 'h', 't', { noremap = true, silent = true })
  vim.keymap.set({'n', 'v', 'o'}, 'j', 'n', { noremap = true, silent = true })
  vim.keymap.set({'n', 'v', 'o'}, 'l', 's', { noremap = true, silent = true })
  
  -- ウィンドウ操作のキーマップ
  vim.keymap.set('n', '<C-w>k', '<C-w>h', { noremap = true, silent = true })
  vim.keymap.set('n', '<C-w>t', '<C-w>j', { noremap = true, silent = true })
  vim.keymap.set('n', '<C-w>n', '<C-w>k', { noremap = true, silent = true })
  vim.keymap.set('n', '<C-w>s', '<C-w>l', { noremap = true, silent = true })
  
  -- 衝突解決: 水平分割を別のキーに
  vim.keymap.set('n', '<C-w>\\', ':split<CR>', { noremap = true, silent = true })
  
  -- 表示行単位での移動
  vim.keymap.set('n', 'gn', 'gk', { desc = 'Move up by display line' })
  vim.keymap.set('n', 'gt', 'gj', { desc = 'Move down by display line' })
end

-- 基本的なキーマップ
vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = 'Save file' })
vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = 'Quit' })
vim.keymap.set('n', '<leader>x', ':x<CR>', { desc = 'Save and quit' })

-- バッファ操作
-- 安全なバッファ削除関数
local function safe_buffer_delete()
  local buf = vim.api.nvim_get_current_buf()
  local buf_name = vim.api.nvim_buf_get_name(buf)
  
  -- 無名バッファまたは変更がない場合は強制削除
  if buf_name == '' or not vim.api.nvim_buf_get_option(buf, 'modified') then
    vim.cmd('bdelete!')
  else
    vim.cmd('bdelete')
  end
end

vim.keymap.set('n', '<leader>bd', safe_buffer_delete, { desc = 'Delete buffer safely' })
vim.keymap.set('n', '<leader>bn', ':bnext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<leader>bp', ':bprevious<CR>', { desc = 'Previous buffer' })

-- インサートモードでの移動
vim.keymap.set('i', '<C-h>', '<Left>')
vim.keymap.set('i', '<C-j>', '<Down>')
vim.keymap.set('i', '<C-k>', '<Up>')
vim.keymap.set('i', '<C-l>', '<Right>')

-- ビジュアルモードでインデント後に選択を維持
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- 検索結果のハイライトを消去
vim.keymap.set('n', '<leader>nh', ':nohl<CR>', { desc = 'Clear search highlights' })

-- ウィンドウ操作
vim.keymap.set('n', '<leader>sv', ':vsplit<CR>', { desc = 'Split window vertically' })
vim.keymap.set('n', '<leader>sh', ':split<CR>', { desc = 'Split window horizontally' })
vim.keymap.set('n', '<leader>se', '<C-w>=', { desc = 'Make windows equal size' })
vim.keymap.set('n', '<leader>sx', ':close<CR>', { desc = 'Close current window' })

-- タブ操作
vim.keymap.set('n', '<leader>to', ':tabnew<CR>', { desc = 'Open new tab' })
vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', { desc = 'Close tab' })
vim.keymap.set('n', '<leader>tn', ':tabn<CR>', { desc = 'Next tab' })
vim.keymap.set('n', '<leader>tp', ':tabp<CR>', { desc = 'Previous tab' })