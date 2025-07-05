# Logical Keymap System v2.0

論理キーマッピングシステム - 配列非依存のキーマップ管理

このドキュメントは、プラグイン化対応版Neovimキーマップシステムの設計、使用方法、およびプラグインとしての配布方法について説明します。

## ドキュメント一覧

- **[ユーザーガイド](USER_GUIDE.md)** - 基本的な使い方と機能説明
- **[プラグインセットアップガイド](PLUGIN_SETUP.md)** - プラグインとしてのインストールと設定方法
- **[技術仕様書](README.md)** (このファイル) - 内部アーキテクチャと拡張方法
- **[非推奨ファイル一覧](DEPRECATED.md)** - 旧アーキテクチャからの移行情報

## クイックスタート

### 既存のdotfilesユーザー
現在の設定ファイル `nvim/lua/config/keymaps/config/user.lua` を編集してカスタマイズ

### プラグインとして使用
```lua
require("config.keymaps.plugin").setup({
  layout_settings = { default_layout = 'onishi' }
})
```

詳細は [プラグインセットアップガイド](PLUGIN_SETUP.md) を参照

## システム概要

このdotfilesのキーマップシステムは、複数の配列（大西配列、QWERTY配列）に対応し、論理的なキー名によってキーマップを定義できる抽象化レイヤーを提供します。v2.0では、プラグイン化に向けたモジュール化とユーザビリティの向上を実現しています。

### 設計目標

1. **ユーザー設定の分離**: カスタマイズは専用の設定ファイルで完結
2. **配列非依存**: 論理キー名による抽象化
3. **動的切り替え**: 実行時に配列を切り替え可能
4. **VSCode統合**: VSCode Neovim拡張との完全な互換性
5. **プラグイン化対応**: 将来的な独立パッケージ化を考慮した設計
6. **設定バリデーション**: エラーの早期発見と安全なフォールバック

## アーキテクチャ

### 依存関係図（v2.0リファクタリング後）

```mermaid
graph TD
    A[user-config.lua<br/>ユーザー設定] --> B[keymaps.lua<br/>メインエントリーポイント]
    B --> C[config-schema.lua<br/>設定バリデーション]
    B --> D[keymap-manager.lua<br/>API層]
    B --> E[layout-manager.lua<br/>配列管理]
    
    D --> F[core.lua<br/>コア機能]
    E --> F
    E --> G[onishi.lua<br/>大西配列]
    E --> H[qwerty.lua<br/>QWERTY配列]
    
    G --> I[common.lua<br/>共通機能]
    G --> J[vscode.lua<br/>VSCode統合]
    H --> I
    H --> J
    
    F --> K[vim.keymap.set<br/>Vim標準API]
    
    style A fill:#e3f2fd
    style B fill:#f3e5f5
    style C fill:#fff3e0
    style D fill:#e8f5e8
    style E fill:#fce4ec
    style F fill:#fff8e1
    style G fill:#e1f5fe
    style H fill:#e1f5fe
    style I fill:#f1f8e9
    style J fill:#fff3e0
    style K fill:#e8f5e8
    
    classDef userLayer fill:#e3f2fd,stroke:#1976d2,stroke-width:3px
    classDef apiLayer fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px
    classDef coreLayer fill:#fff8e1,stroke:#f57c00,stroke-width:3px
    classDef systemLayer fill:#fce4ec,stroke:#c2185b,stroke-width:2px
    classDef configLayer fill:#e1f5fe,stroke:#0288d1,stroke-width:2px
    classDef utilLayer fill:#f1f8e9,stroke:#689f38,stroke-width:2px
    classDef vimApi fill:#e8f5e8,stroke:#388e3c,stroke-width:2px
    
    class A userLayer
    class B,D apiLayer
    class F coreLayer
    class C,E systemLayer
    class G,H configLayer
    class I,J utilLayer
    class K vimApi
```

### レイヤー構成

1. **ユーザー層** (`keymaps.lua`)
   - ユーザーが直接編集する設定ファイル
   - 論理キー名（up/down/left/right）でキーマップを定義

2. **抽象化層** (`keymap-manager.lua`)
   - 論理キー名を実際のキーに変換
   - 統一されたAPIを提供
   - ユーザーから内部実装を隠蔽

3. **システム層** (`layout-manager.lua`)
   - 配列切り替えとコマンド管理
   - 現在の配列状態を追跡
   - 配列固有の論理キーマッピングを提供

4. **設定層** (各配列定義ファイル)
   - 配列固有のキーマップ定義
   - VSCode固有の処理
   - 共通ユーティリティ関数

5. **Vim層** (`vim.keymap.set`)
   - Vimの標準キーマップAPI
   - 最終的なキーマップの実装

## ファイル詳細

### keymap-manager.lua

論理キーマッピングのためのAPIを提供します。

#### 主要関数

```lua
-- 基本的な論理キーマッピング
km.map(logical_key, target, opts)

-- モード指定可能なマッピング
km.map_mode(modes, logical_key, target, opts)

-- リーダーキーマッピング
km.map_leader(key, target, opts)
km.map_local_leader(key, target, opts)

-- 一括マッピング
km.map_bulk(mappings, opts)
```

#### 論理キー対応表

| 論理キー | 大西配列 | QWERTY配列 |
|---------|---------|-----------|
| `up` | n | k |
| `down` | t | j |
| `left` | k | h |
| `right` | s | l |

### layout-manager.lua

配列管理とコマンド登録を担当します。

#### 提供コマンド

```vim
:ToggleKeymap    " 配列をトグル
:KeymapOnishi    " 大西配列に設定
:KeymapQwerty    " QWERTY配列に設定
:KeymapStatus    " 現在の配列状態を表示
```

#### 状態管理

- 現在の配列は `vim.g.keymap_layout` に保存
- 起動時に前回の設定を復元
- 配列切り替え時に既存のキーマップをクリア

### 配列定義ファイル (onishi.lua, qwerty.lua)

各配列固有のキーマップ定義を含みます。

#### 構造

```lua
local config = {
  -- NeovimとVSCode共通の基本マッピング
  normal = {
    ['n'] = 'up',
    ['t'] = 'down',
    -- ...
  },
  
  -- VSCode固有のマッピング
  vscode_normal = {
    ['n'] = 'up',
    ['t'] = 'down',
    -- ...
  },
  
  -- Neovim固有のマッピング
  neovim_basic = {
    ['n'] = 'k',
    ['t'] = 'j',
    -- ...
  },
  
  -- 交換マッピング（元のキーも同時に設定）
  neovim_swap = {
    ['k'] = 'n',  -- k -> n, n -> k
    -- ...
  }
}

return {
  setup = function()
    vscode.setup_keymaps(config)
    common.setup_neovim_keymaps(config)
  end,
  clear = function()
    -- キーマップ削除処理
  end
}
```

### common.lua

共通ユーティリティ関数を提供します。

#### 主要関数

```lua
-- VSCode環境判定
M.is_vscode

-- キーマップ安全削除
M.clear_keymaps(keys)

-- Neovim環境での基本マッピング設定
M.setup_neovim_keymaps(keymap_config)
```

### vscode.lua

VSCode Neovim拡張固有の処理を担当します。

## 新しい配列の追加

### 1. 配列定義ファイルの作成

```lua
-- dvorak.lua
local common = require('config.keymaps.common')
local vscode = require('config.keymaps.vscode')

local dvorak_config = {
  normal = {
    -- Dvorak配列での基本マッピング
  },
  vscode_normal = {
    -- VSCode固有マッピング
  },
  neovim_basic = {
    -- Neovim基本マッピング
  },
  neovim_swap = {
    -- 交換マッピング
  }
}

return {
  setup = function()
    vscode.setup_keymaps(dvorak_config)
    common.setup_neovim_keymaps(dvorak_config)
  end,
  clear = function()
    local keys_to_clear = {
      -- クリアするキーのリスト
    }
    common.clear_keymaps(keys_to_clear)
  end
}
```

### 2. layout-manager.luaの更新

```lua
-- 配列のrequire追加
local dvorak = require('config.keymaps.dvorak')

-- 論理キーマッピング定義に追加
local key_mappings = {
  dvorak = { 
    up = ',', 
    down = 'o',
    left = 'a',
    right = 'e'
  },
  -- ...
}

-- switch_layout関数にケース追加
elseif layout == 'dvorak' then
  dvorak.setup()
  current_layout = 'dvorak'
  vim.g.keymap_layout = 'dvorak'
```

### 3. コマンドの追加

```lua
vim.api.nvim_create_user_command('KeymapDvorak', function()
  switch_layout('dvorak')
end, {
  desc = 'キーマップをDvorak配列に設定'
})
```

## 高度なカスタマイズ

### カスタム論理キーの追加

新しい論理キー（例：`word_left`, `word_right`）を追加する場合：

```lua
-- layout-manager.luaで論理キーマッピングを拡張
local key_mappings = {
  onishi = { 
    -- 既存のマッピング
    word_left = 'b',
    word_right = 'w'
  }
}

-- keymap-manager.luaで使用
km.map('word_left', 'B', { desc = 'Move to previous word' })
km.map('word_right', 'W', { desc = 'Move to next word' })
```

### 条件付きキーマップ

```lua
-- 特定のファイルタイプでのみ有効なキーマップ
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'lua',
  callback = function()
    km.map_local_leader('r', ':luafile %<CR>', { 
      desc = 'Run current Lua file',
      buffer = true 
    })
  end,
})
```

### 動的キーマップ

```lua
-- プラグインの状態に応じたキーマップ
local function toggle_diagnostic()
  if vim.diagnostic.is_disabled() then
    vim.diagnostic.enable()
    km.map_leader('d', vim.diagnostic.open_float, { desc = 'Show diagnostics' })
  else
    vim.diagnostic.disable()
    vim.keymap.del('n', '<leader>d')
  end
end
```

## トラブルシューティング

### よくある問題

1. **キーマップが効かない**
   - 現在の配列設定を確認: `:KeymapStatus`
   - 競合するキーマップがないか確認: `:map {key}`

2. **配列切り替えがうまくいかない**
   - `vim.g.keymap_layout` の値を確認
   - 手動で初期化: `require('config.keymaps.layout-manager').init()`

3. **VSCodeで動作しない**
   - `vim.g.vscode` が正しく設定されているか確認
   - VSCode固有のマッピングが定義されているか確認

### デバッグ方法

```lua
-- 現在のキーマップを確認
print(vim.inspect(vim.api.nvim_get_keymap('n')))

-- 論理キーの実際のマッピングを確認
local km = require('config.keymaps.keymap-manager')
print(km.get_current_layout())
print(vim.inspect(km.get_available_keys()))
```

## パフォーマンス考慮事項

- キーマップの切り替えは既存のマッピングを削除してから新しいものを設定
- 起動時の初期化は1回のみ実行
- 論理キーの解決はキーマップ設定時に実行（実行時ではない）

## プラグインとしての使用方法

### プラグインマネージャーでのインストール

#### lazy.nvim

```lua
{
  "user/logical-keymap",
  config = function()
    require("logical-keymap").setup({
      -- 基本設定
      leader_keys = {
        leader = " ",
        localleader = " ",
      },
      -- 基本的なキーマップ
      basic_keymaps = {
        { logical_key = 'down', target = 'gj', opts = { silent = true, desc = 'Move down by display line' } },
        { logical_key = 'up', target = 'gk', opts = { silent = true, desc = 'Move up by display line' } },
      },
      -- 配列設定
      layout_settings = {
        default_layout = 'onishi',
        enable_layout_switching = true,
      },
    })
  end,
}
```

#### packer.nvim

```lua
use {
  'user/logical-keymap',
  config = function()
    require('logical-keymap').setup()
  end
}
```

### API使用例

```lua
local keymap = require('logical-keymap')

-- 基本的なマッピング
keymap.map('up', 'gk', { desc = 'Move up by display line' })
keymap.map('down', 'gj', { desc = 'Move down by display line' })

-- リーダーキーマッピング
keymap.map_leader('w', ':w<CR>', { desc = 'Save file' })

-- 一括マッピング
keymap.map_bulk({
  left = 'B',
  right = 'W'
}, { desc = 'Word navigation' })

-- 配列切り替え
keymap.toggle()          -- 配列をトグル
keymap.set_layout('qwerty')  -- QWERTY配列に設定

-- 状態確認
print(vim.inspect(keymap.status()))
```

### カスタム配列の追加

```lua
-- カスタム配列を登録
local keymap = require('logical-keymap')

keymap.core.register_layout('dvorak', {
  layout_name = "dvorak",
  display_name = "Dvorak配列",
  logical_mapping = {
    up = ",",
    down = "o", 
    left = "a",
    right = "e"
  },
  vscode_config = {
    normal = {
      [","] = "up",
      ["o"] = "down",
      ["a"] = "left", 
      ["e"] = "right"
    }
  },
  neovim_config = {
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
    supports_vscode = true,
    supports_neovim = true
  }
})

-- 使用
keymap.set_layout('dvorak')
```

## 将来の拡張計画

### v2.1
- プラグインマネージャー対応の完全版リリース
- 設定マイグレーション機能
- 詳細なドキュメントサイト

### v2.2
- 複数の論理キーセットのサポート
- キーマップのインポート/エクスポート機能
- 高度なカスタマイズオプション

### v3.0
- GUIでの配列切り替えインターフェース
- キーマップの使用統計とヒートマップ
- マルチプラットフォーム対応の強化