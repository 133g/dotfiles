# Logical Keymap System - ユーザーガイド

論理キーマッピングシステムの使い方と機能説明

## 目次

1. [概要](#概要)
2. [基本機能](#基本機能)
3. [クイックスタート](#クイックスタート)
4. [詳細な使い方](#詳細な使い方)
5. [カスタマイズ](#カスタマイズ)
6. [よくある質問](#よくある質問)

## 概要

### このシステムの目的

Logical Keymap Systemは、**キーボード配列に依存しない**キーマップ設定を可能にするNeovimプラグインです。

#### 解決する問題

- **配列切り替えの手間**: 大西配列とQWERTY配列を使い分ける際のキーマップ再設定
- **設定の複雑化**: 配列ごとに異なるキーマップ設定の管理

#### 提供する価値

- **論理キー名での設定**: `up`、`down`、`left`、`right`で直感的にキーマップを定義
- **自動配列切り替え**: `:ToggleKeymap`で瞬時に配列を切り替え
- **統一されたキーマップ体験**: 配列非依存のキーマップ管理

## 基本機能

### 1. 論理キーマッピング

従来の物理キー指定：
```lua
vim.keymap.set('n', 'k', 'gk')  -- 大西配列では使いにくい
```

論理キー指定：
```lua
km.map('up', 'gk', { desc = 'Move up by display line' })  -- どの配列でも直感的
```

### 2. 配列自動切り替え

| 配列 | up | down | left | right |
|------|----|----- |------|-------|
| 大西配列 | n | t | k | s |
| QWERTY配列 | k | j | h | l |

一度設定すれば、配列切り替え時に自動で適切なキーに変換されます。

### 3. コマンド

- `:ToggleKeymap` - 配列をトグル切り替え
- `:KeymapOnishi` - 大西配列に設定  
- `:KeymapQwerty` - QWERTY配列に設定
- `:KeymapStatus` - 現在の配列状態を表示

## クイックスタート

### 1. 基本的な使い方

現在の設定ファイル：`nvim/lua/config/keymaps/config/user.lua`

```lua
-- 基本的なキーマップ追加例
M.basic_keymaps = {
  { logical_key = 'down', target = 'gj', opts = { silent = true, desc = 'Move down by display line' } },
  { logical_key = 'up', target = 'gk', opts = { silent = true, desc = 'Move up by display line' } },
  -- 新しいマッピングを追加
  { logical_key = 'left', target = 'B', opts = { desc = 'Move to previous word' } },
  { logical_key = 'right', target = 'W', opts = { desc = 'Move to next word' } },
}
```

### 2. リーダーキーマッピング

```lua
M.leader_keymaps = {
  { key = 'w', target = ':w<CR>', opts = { desc = 'Save file' } },
  { key = 'q', target = ':q<CR>', opts = { desc = 'Quit' } },
  { key = 'f', target = ':Telescope find_files<CR>', opts = { desc = 'Find files' } },
}
```

### 3. ファイルタイプ固有のマッピング

```lua
M.filetype_keymaps = {
  lua = {
    { key = 'r', target = ':luafile %<CR>', opts = { desc = 'Run current Lua file' } },
    { key = 't', target = ':luafile %<CR>', opts = { desc = 'Test current Lua file' } },
  },
  javascript = {
    { key = 'r', target = ':!node %<CR>', opts = { desc = 'Run with Node.js' } },
  },
  python = {
    { key = 'r', target = ':!python %<CR>', opts = { desc = 'Run with Python' } },
  },
}
```

## 詳細な使い方

### 配列切り替えの動作

#### 手動切り替え
```vim
:ToggleKeymap    " 大西配列 ⇔ QWERTY配列
:KeymapOnishi    " 大西配列に固定
:KeymapQwerty    " QWERTY配列に固定
```

#### 自動保存
現在の配列状態は自動で保存され、次回起動時に復元されます。

### 高度なカスタマイズ

#### 一括マッピング
```lua
M.bulk_keymaps = {
  {
    mappings = { 
      left = 'B',   -- 前の単語
      right = 'W'   -- 次の単語
    }, 
    opts = { desc = 'Word navigation' }
  },
}
```

#### 条件付きマッピング
```lua
-- プラグインが利用可能な場合のみ設定
if vim.fn.exists(':Telescope') == 2 then
  table.insert(M.leader_keymaps, {
    key = 'f',
    target = ':Telescope find_files<CR>',
    opts = { desc = 'Find files' }
  })
end
```

#### カスタム配列の追加

Dvorak配列を追加する例：

```lua
M.advanced_settings = {
  custom_layouts = {
    dvorak = {
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
      clear_keys = {",", "o", "a", "e"},
      compatibility = {
        version = "2.0",
        supports_neovim = true
      }
    }
  }
}
```

## よくある質問

### Q: 既存のキーマップとの競合は？

**A:** 本システムは既存のキーマップを尊重し、競合を最小限に抑えるよう設計されています。配列切り替え時には該当するキーのみをクリアしてから新しい設定を適用します。

### Q: パフォーマンスへの影響は？

**A:** 
- 起動時の初期化は最小限
- 遅延読み込みでメモリ使用量を最適化
- キーマップ解決は設定時に実行（実行時オーバーヘッドなし）

### Q: カスタム論理キーを追加できますか？

**A:** はい、可能です。以下のように設定できます：

```lua
-- カスタム論理キーを定義
local custom_mapping = {
  word_left = 'B',
  word_right = 'W', 
  para_up = '{',
  para_down = '}'
}

-- 使用
M.basic_keymaps = {
  { logical_key = 'word_left', target = 'B', opts = { desc = 'Previous word' } },
  { logical_key = 'word_right', target = 'W', opts = { desc = 'Next word' } },
}
```

### Q: トラブルシューティング

#### キーマップが効かない場合
1. 現在の配列を確認: `:KeymapStatus`
2. 競合するマッピングを確認: `:map <key>`
3. 設定を再読み込み: `:luafile ~/.config/nvim/lua/config/keymaps.lua`

#### 配列切り替えがうまくいかない場合
1. 手動で初期化: `:lua require('config.keymaps.plugin.layout-engine').init()`
2. 状態を確認: `:lua print(vim.inspect(require('config.keymaps.plugin.layout-engine').debug_info()))`


### Q: 設定のバックアップとマイグレーション

現在の設定をバックアップしたい場合：

```bash
# 設定ファイルをバックアップ
cp ~/.config/nvim/lua/config/keymaps/config/user.lua ~/.config/nvim/lua/config/keymaps/config/user.lua.backup

# 新しい設定をテスト後、問題があれば復元
mv ~/.config/nvim/lua/config/keymaps/config/user.lua.backup ~/.config/nvim/lua/config/keymaps/config/user.lua
```

## さらに詳しく

- [技術仕様書](README.md) - 内部アーキテクチャや拡張方法
- [設定スキーマ](config-schema.lua) - 設定可能なオプションの完全なリスト
- [API リファレンス](plugin/keymap-api.lua) - プログラマティックな使用方法