# Logical Keymap System - ユーザーガイド

配列非依存の移動キー抽象化ライブラリの使い方

## 目次

1. [概要](#概要)
2. [基本機能](#基本機能)
3. [クイックスタート](#クイックスタート)
4. [詳細な使い方](#詳細な使い方)
5. [カスタマイズ](#カスタマイズ)
6. [よくある質問](#よくある質問)

## 概要

### このプラグインの目的

Logical Keymap Systemは、**移動キーの論理抽象化**を提供するNeovimプラグインです。

#### 解決する問題

- **配列切り替え時のキーマップ破綻**: 移動キーが配列ごとに異なる問題
- **物理キー依存の設定**: `h`/`j`/`k`/`l`でのマッピングの非直感性

#### 提供する価値

- **移動キーの論理抽象化**: `up`/`down`/`left`/`right`で直感的に設定
- **安全な配列切り替え**: ユーザーマッピングが破綻しない保証
- **ミニマルな責務**: 移動キーのみに焦点した軽量プラグイン

## 基本機能

### 1. 論理キーマッピングAPI

従来の物理キー指定：
```lua
vim.keymap.set('n', 'k', 'gk')  -- 大西配列では直感的でない
```

論理キー指定（プラグイン使用）：
```lua
local lk = require('logical-keymap')
lk.map('up', 'gk', { desc = 'Move up by display line' })  -- 直感的
```

### 2. 配列定義と切り替え

| 配列 | up | down | left | right |
|------|----|-----|------|-------|
| 大西配列 | n | t | k | s |
| QWERTY配列 | k | j | h | l |

**重要**: プラグインは移動キーの抽象化のみを提供します。ユーザーは自分でキーマップを設定し、配列切り替え後に再適用します。

### 3. コマンド

- `:ToggleKeymap` - 配列をトグル切り替え
- `:KeymapOnishi` - 大西配列に設定  
- `:KeymapQwerty` - QWERTY配列に設定
- `:KeymapStatus` - 現在の配列状態を表示

## クイックスタート

### 1. プラグインのセットアップ

```lua
-- init.lua でプラグインを初期化
require('logical-keymap').setup({
  default_layout = 'onishi',  -- または 'qwerty'
  enable_layout_switching = true,
  enable_commands = true,
})
```

### 2. 論理キーマッピングの設定

```lua
-- ユーザーが自分でキーマップを設定
local lk = require('logical-keymap')

-- 移動キーの論理マッピング
lk.map('up', 'gk', { desc = 'Move up by display line' })
lk.map('down', 'gj', { desc = 'Move down by display line' })
lk.map('left', 'B', { desc = 'Move to previous word' })
lk.map('right', 'W', { desc = 'Move to next word' })

-- 普通のキーマップは普通に設定
vim.g.mapleader = " "
vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = 'Save file' })
vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = 'Quit' })
```

### 3. 配列切り替え時の再適用

```lua
-- 配列切り替え後にユーザーマッピングを再適用
vim.api.nvim_create_autocmd('User', {
  pattern = 'KeymapLayoutChanged',
  callback = function()
    -- 論理キーマッピングを再設定
    lk.map('up', 'gk', { desc = 'Move up by display line' })
    lk.map('down', 'gj', { desc = 'Move down by display line' })
    lk.map('left', 'B', { desc = 'Move to previous word' })
    lk.map('right', 'W', { desc = 'Move to next word' })
  end
})
```

## 詳細な使い方

### 配列切り替えの動作

#### 手動切り替え
```vim
:ToggleKeymap    " 大西配列 ⇔ QWERTY配列
:KeymapOnishi    " 大西配列に固定
:KeymapQwerty    " QWERTY配列に固定
```

#### 重要: ユーザー責務
プラグインは配列を切り替えるだけで、**ユーザーが設定したキーマップの再適用はユーザーの責務**です。上記の`KeymapLayoutChanged`イベントを使用してください。

### 高度な使い方

#### カスタムヘルパー関数
```lua
-- ユーザー自作のヘルパー関数
local lk = require('logical-keymap')

local function setup_my_keymaps()
  lk.map('up', 'gk', { desc = 'Move up by display line' })
  lk.map('down', 'gj', { desc = 'Move down by display line' })
  lk.map('left', 'B', { desc = 'Previous word' })
  lk.map('right', 'W', { desc = 'Next word' })
end

-- 初回設定
setup_my_keymaps()

-- 配列切り替え時の再適用
vim.api.nvim_create_autocmd('User', {
  pattern = 'KeymapLayoutChanged',
  callback = setup_my_keymaps
})
```

#### 条件付きマッピング
```lua
-- プラグインが利用可能な場合のみ設定
if vim.fn.exists(':Telescope') == 2 then
  vim.keymap.set('n', '<leader>f', ':Telescope find_files<CR>', { desc = 'Find files' })
end
```

## カスタマイズ

#### カスタム配列の追加

Dvorak配列を追加する例：

```lua
-- カスタム配列を登録
local lk = require('logical-keymap')

lk.register_layout('dvorak', {
  layout_name = "dvorak",
  display_name = "Dvorak配列",
  logical_mapping = {
    up = ",",
    down = "o",
    left = "a", 
    right = "e"
  },
  key_mappings = {
    basic = {
      [","] = "k",
      ["o"] = "j",
      ["a"] = "h", 
      ["e"] = "l"
    }
  },
  clear_keys = {",", "o", "a", "e"}
})

-- 使用
lk.set_layout('dvorak')
```

## よくある質問

### Q: 既存のキーマップとの競合は？

**A:** 本プラグインは移動キーの抽象化のみを提供し、最小限の介入で動作します。配列切り替え時には該当する移動キーのみをクリアしてから新しい設定を適用します。

### Q: パフォーマンスへの影響は？

**A:** 
- 起動時の初期化は最小限
- 移動キーの抽象化のみなので軽量
- キーマップ解決は設定時に実行（実行時オーバーヘッドなし）

### Q: リーダーキーやファイルタイプマッピングは？

**A:** このプラグインは移動キーの抽象化のみを責務とします。リーダーキーやファイルタイプマッピングは従来通りユーザーが設定してください：

```lua
-- 普通に設定
vim.g.mapleader = " "
vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = 'Save file' })

-- ファイルタイプ固有マッピング
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'lua',
  callback = function()
    vim.keymap.set('n', '<localleader>r', ':luafile %<CR>', { buffer = true, desc = 'Run Lua file' })
  end,
})
```

### Q: トラブルシューティング

#### キーマップが効かない場合
1. 現在の配列を確認: `:KeymapStatus`
2. 競合するマッピングを確認: `:map <key>`
3. プラグインのAPI確認: `:lua print(vim.inspect(require('logical-keymap').status()))`

#### 配列切り替えがうまくいかない場合
1. 手動で初期化: `:lua require('logical-keymap').setup()`
2. 状態を確認: `:lua print(vim.inspect(require('logical-keymap').get_layout()))`

### Q: 設定のバックアップ

プラグインの設定は最小限なので、主要な設定はユーザーのinit.luaに記述されます。通常のNeovim設定のバックアップ方法で十分です。

## さらに詳しく

- [プラグインセットアップガイド](PLUGIN_SETUP.md) - プラグインマネージャーでのインストール
- [技術仕様書](README.md) - 内部アーキテクチャや拡張方法