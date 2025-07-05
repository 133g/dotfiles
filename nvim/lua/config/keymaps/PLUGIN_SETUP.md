# Logical Keymap System - プラグインセットアップガイド

このドキュメントは、Logical Keymap Systemを独立したプラグインとして使用する方法を説明します。

## インストール方法

### lazy.nvim

```lua
{
  -- 将来的にはGitHubリポジトリからインストール
  -- "username/logical-keymap.nvim",
  
  -- 現在はローカルパスを指定（テスト用）
  dir = "~/.config/nvim/lua/config/keymaps",
  name = "logical-keymap",
  
  config = function()
    -- プラグインのセットアップ
    require("config.keymaps.plugin").setup({
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
      
      -- リーダーキーマッピング
      leader_keymaps = {
        { key = 'w', target = ':w<CR>', opts = { desc = 'Save file' } },
        { key = 'q', target = ':q<CR>', opts = { desc = 'Quit' } },
      },
      
      -- 配列設定
      layout_settings = {
        default_layout = 'onishi',
        enable_layout_switching = true,
        auto_save_layout = true,
      },
      
      
      -- プラグイン設定
      plugin_settings = {
        enable_commands = true,
        enable_autocmds = true,
        debug_mode = false,
      },
    })
  end,
  
  -- キーマップ
  keys = {
    { "<leader>kt", "<cmd>ToggleKeymap<cr>", desc = "Toggle keymap layout" },
    { "<leader>ko", "<cmd>KeymapOnishi<cr>", desc = "Set Onishi layout" },
    { "<leader>kq", "<cmd>KeymapQwerty<cr>", desc = "Set QWERTY layout" },
    { "<leader>ks", "<cmd>KeymapStatus<cr>", desc = "Show keymap status" },
  },
  
  -- 遅延読み込み
  event = "VeryLazy",
}
```

### packer.nvim

```lua
use {
  -- 将来的にはGitHubリポジトリからインストール
  -- 'username/logical-keymap.nvim',
  
  -- 現在はローカルパスを指定（テスト用）
  '~/.config/nvim/lua/config/keymaps',
  as = 'logical-keymap',
  
  config = function()
    require('config.keymaps.plugin').setup({
      -- 設定は上記のlazy.nvimと同じ
    })
  end
}
```

### vim-plug

```vim
" ~/.config/nvim/lua/config/keymapsを使用（テスト用）
Plug 'username/logical-keymap.nvim'

lua << EOF
require('config.keymaps.plugin').setup({
  -- 設定をここに記述
})
EOF
```

## 設定例集

### ミニマル設定

```lua
require("config.keymaps.plugin").setup({
  layout_settings = {
    default_layout = 'qwerty',  -- QWERTY配列のみ使用
    enable_layout_switching = false,
  },
})
```

### フル設定

```lua
require("config.keymaps.plugin").setup({
  -- リーダーキー
  leader_keys = {
    leader = " ",
    localleader = ",",
  },
  
  -- 基本キーマップ
  basic_keymaps = {
    { logical_key = 'down', target = 'gj', opts = { silent = true, desc = 'Move down by display line' } },
    { logical_key = 'up', target = 'gk', opts = { silent = true, desc = 'Move up by display line' } },
    { logical_key = 'left', target = 'B', opts = { desc = 'Move to previous word' } },
    { logical_key = 'right', target = 'W', opts = { desc = 'Move to next word' } },
  },
  
  -- リーダーキーマッピング
  leader_keymaps = {
    { key = 'w', target = ':w<CR>', opts = { desc = 'Save file' } },
    { key = 'q', target = ':q<CR>', opts = { desc = 'Quit' } },
    { key = 'h', target = ':nohlsearch<CR>', opts = { desc = 'Clear highlights' } },
    { key = 'e', target = ':Explore<CR>', opts = { desc = 'File explorer' } },
  },
  
  -- ローカルリーダーキーマッピング
  local_leader_keymaps = {
    { key = 'r', target = ':luafile %<CR>', opts = { desc = 'Run current file' } },
  },
  
  -- 一括マッピング
  bulk_keymaps = {
    {
      mappings = { 
        left = 'B',   -- 前の単語
        right = 'W'   -- 次の単語
      },
      opts = { desc = 'Word navigation' }
    },
  },
  
  -- ファイルタイプ固有
  filetype_keymaps = {
    lua = {
      { key = 'r', target = ':luafile %<CR>', opts = { desc = 'Run Lua file' } },
      { key = 't', target = ':PlenaryBustedFile %<CR>', opts = { desc = 'Test Lua file' } },
    },
    javascript = {
      { key = 'r', target = ':!node %<CR>', opts = { desc = 'Run with Node.js' } },
    },
    python = {
      { key = 'r', target = ':!python %<CR>', opts = { desc = 'Run with Python' } },
    },
    markdown = {
      { key = 'p', target = ':MarkdownPreview<CR>', opts = { desc = 'Preview markdown' } },
    },
  },
  
  -- 配列設定
  layout_settings = {
    default_layout = 'onishi',
    enable_layout_switching = true,
    auto_save_layout = true,
  },
  
  
  -- プラグイン設定
  plugin_settings = {
    enable_commands = true,
    enable_autocmds = true,
    debug_mode = false,
  },
  
  -- パフォーマンス設定
  performance_settings = {
    lazy_loading = true,
    cache_layouts = true,
    validation_level = "normal",
  },
  
  -- 高度な設定
  advanced_settings = {
    -- カスタム配列
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
    },
    
    -- フック関数
    hooks = {
      before_layout_switch = function(from_layout, to_layout)
        print("配列を " .. from_layout .. " から " .. to_layout .. " に切り替えます")
      end,
      after_layout_switch = function(layout)
        print("配列を " .. layout .. " に切り替えました")
      end,
    },
  },
})
```

## API使用例

### 基本的なAPI使用

```lua
-- プラグインの取得
local logical_keymap = require('config.keymaps.plugin')

-- 基本的なマッピング
logical_keymap.map('up', 'gk', { desc = 'Move up by display line' })
logical_keymap.map('down', 'gj', { desc = 'Move down by display line' })

-- リーダーキーマッピング
logical_keymap.map_leader('w', ':w<CR>', { desc = 'Save file' })
logical_keymap.map_local_leader('r', ':luafile %<CR>', { desc = 'Run file' })

-- 一括マッピング
logical_keymap.map_bulk({
  left = 'B',
  right = 'W'
}, { desc = 'Word navigation' })

-- 配列操作
logical_keymap.toggle()              -- 配列をトグル
logical_keymap.set_layout('qwerty')  -- QWERTY配列に設定
print(logical_keymap.get_layout())   -- 現在の配列を取得

-- 状態確認
print(vim.inspect(logical_keymap.status()))
```

### 条件付きセットアップ

```lua
-- 特定の条件下でのみプラグインを有効化
local function should_enable_logical_keymap()
  -- 例：特定のディレクトリ内でのみ有効
  local cwd = vim.fn.getcwd()
  return string.match(cwd, "/my-special-project")
end

if should_enable_logical_keymap() then
  require("config.keymaps.plugin").setup({
    -- 設定
  })
end
```

### 他のプラグインとの統合

```lua
-- Telescope.nvimとの統合例
require("config.keymaps.plugin").setup({
  leader_keymaps = {
    { key = 'f', target = function()
      require('telescope.builtin').find_files()
    end, opts = { desc = 'Find files' } },
    
    { key = 'g', target = function()
      require('telescope.builtin').live_grep()
    end, opts = { desc = 'Live grep' } },
  },
})

-- which-key.nvimとの統合例
local wk = require("which-key")
wk.register({
  ["<leader>k"] = {
    name = "Keymap",
    t = { "<cmd>ToggleKeymap<cr>", "Toggle layout" },
    o = { "<cmd>KeymapOnishi<cr>", "Onishi layout" },
    q = { "<cmd>KeymapQwerty<cr>", "QWERTY layout" },
    s = { "<cmd>KeymapStatus<cr>", "Show status" },
  }
})
```

## トラブルシューティング

### よくある問題

#### 1. プラグインが読み込まれない

```lua
-- デバッグ用：プラグインの状態確認
:lua print(vim.inspect(require('config.keymaps.plugin').status()))
```

#### 2. キーマップが効かない

```lua
-- 現在のキーマップ確認
:map <key>

-- プラグインのキーマップを再適用
:lua require('config.keymaps.plugin').setup()
```

#### 3. 配列切り替えが動作しない

```lua
-- エンジンの状態確認
:lua print(vim.inspect(require('config.keymaps.plugin.layout-engine').debug_info()))

-- 手動で配列切り替え
:lua require('config.keymaps.plugin').set_layout('qwerty')
```

### パフォーマンス最適化

```lua
require("config.keymaps.plugin").setup({
  performance_settings = {
    lazy_loading = true,        -- 遅延読み込み有効
    cache_layouts = true,       -- 配列定義をキャッシュ
    validation_level = "minimal", -- バリデーションを最小限に
  },
  
  plugin_settings = {
    debug_mode = false,         -- デバッグモード無効
  },
})
```

## 次のステップ

1. [ユーザーガイド](USER_GUIDE.md) - 詳細な使い方
2. [技術仕様書](README.md) - 内部アーキテクチャ
3. [カスタム配列の作成方法](USER_GUIDE.md#カスタム配列の追加)