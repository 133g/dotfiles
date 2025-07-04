local onishi = require('config.keymaps.onishi')
local qwerty = require('config.keymaps.qwerty')

-- 現在の配列状態を管理
local current_layout = vim.g.keymap_layout or 'onishi'

-- 配列の切り替え機能
local function switch_layout(layout, is_initial)
  -- 現在のキーマップを削除
  if current_layout == 'onishi' then
    onishi.clear()
  elseif current_layout == 'qwerty' then
    qwerty.clear()
  end
  
  -- 新しいキーマップを設定
  if layout == 'onishi' then
    onishi.setup()
    current_layout = 'onishi'
    vim.g.keymap_layout = 'onishi'
    if is_initial then
      print('Keymap: Onishi')
    else
      print('Keymap: Switched to Onishi')
    end
  elseif layout == 'qwerty' then
    qwerty.setup()
    current_layout = 'qwerty'
    vim.g.keymap_layout = 'qwerty'
    if is_initial then
      print('Keymap: QWERTY')
    else
      print('Keymap: Switched to QWERTY')
    end
  end
end

-- トグル機能
local function toggle_layout()
  if current_layout == 'onishi' then
    switch_layout('qwerty')
  else
    switch_layout('onishi')
  end
end

-- コマンドの登録
vim.api.nvim_create_user_command('ToggleKeymap', toggle_layout, {
  desc = 'キーマップ配列を切り替え（大西配列 ⇔ QWERTY配列）'
})

vim.api.nvim_create_user_command('KeymapOnishi', function()
  switch_layout('onishi')
end, {
  desc = 'キーマップを大西配列に設定'
})

vim.api.nvim_create_user_command('KeymapQwerty', function()
  switch_layout('qwerty')
end, {
  desc = 'キーマップをQWERTY配列に設定'
})

-- 現在の配列状態を表示
vim.api.nvim_create_user_command('KeymapStatus', function()
  print('Keymap: ' .. current_layout:upper())
end, {
  desc = 'Show current keymap layout'
})

-- 起動時の初期化
switch_layout(current_layout, true)