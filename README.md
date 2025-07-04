# dotfiles

macOS、Linux、WSL2に対応したモダンなdotfiles構成。XDG Base Directory仕様準拠で、統一されたキーマッピング（k=左、t=下、n=上、s=右）を全ツールで採用。

## 特徴

- **XDG Base Directory準拠**: すべての設定ファイルを`~/.config/`以下に統一
- **マルチプラットフォーム対応**: macOS、Linux、WSL2を自動検出してプラットフォーム固有の設定を適用
- **統一キーマッピング**: Neovim、tmux、シェルで一貫したキーバインド（k=左、t=下、n=上、s=右）
- **安全なインストール**: 既存ファイルの自動バックアップと冪等性を保証
- **モジュラー構成**: ディレクトリ単位でのシンボリックリンク管理

## 構成

```
dotfiles/
├── nvim/               # Neovim設定（lazy.nvim + nordfox）
│   ├── init.lua
│   └── lua/config/
│       ├── options.lua     # 基本設定
│       ├── keymaps.lua     # キーマップ管理
│       ├── keymaps/        # キーマップ詳細設定
│       │   ├── common.lua      # 共通機能
│       │   ├── vscode.lua      # VSCode専用設定
│       │   ├── onishi.lua      # 大西配列
│       │   └── qwerty.lua      # QWERTY配列
│       ├── ime.lua         # IME設定
│       ├── wsl.lua         # WSL2設定
│       └── lazy.lua        # プラグイン管理
├── claude/             # Claude Code hooks・スクリプト
│   ├── settings.json       # hooks設定
│   ├── discord-config.json.example  # Discord設定例
│   ├── scripts/
│   │   ├── discord-notify.sh   # Discord通知スクリプト
│   │   └── setup-discord.sh    # セットアップスクリプト
│   └── README.md       # Claude設定ドキュメント
├── zsh/            # Zsh設定（Sheldon + Powerlevel10k）
├── tmux/           # Tmux設定（カスタムキーバインド）
├── sheldon/        # Zsh plugin manager設定
├── ghostty/        # Ghostty terminal設定（macOSのみ）
├── p10k/           # Powerlevel10k prompt設定
└── bin/            # インストールスクリプト
```

## インストール

### 前提条件

- Git
- Zsh
- 対応OS: macOS, Linux, WSL2 (Ubuntu)

### クイックスタート

```bash
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./bin/install.sh
```

インストールスクリプトが自動的に：
- OS環境を検出
- 既存ファイルを`~/.dotbackup/`にバックアップ
- XDG Base Directory準拠でシンボリックリンクを作成
- zsh用のブートストラップファイル（`~/.zshenv`）を作成

### インストール内容

| ソース | リンク先 | 説明 |
|--------|----------|------|
| `nvim/` | `~/.config/nvim/` | Neovim設定 |
| `zsh/` | `~/.config/zsh/` | Zsh設定 |
| `tmux/` | `~/.config/tmux/` | Tmux設定 |
| `sheldon/` | `~/.config/sheldon/` | Zshプラグイン管理 |
| `p10k/` | `~/.config/p10k/` | Powerlevel10kテーマ |
| `claude/` | `~/.claude/` | Claude Code hooks・スクリプト |
| `ghostty/`* | `~/Library/Application Support/com.mitchellh.ghostty` | Ghostty設定（macOSのみ） |

*macOSでのみ作成されます

## 主要ツール設定

### Neovim
- **プラグイン管理**: lazy.nvim
- **カラーテーマ**: nordfox
- **キーマッピング**: 大西配列（k=左、t=下、n=上、s=右）とQWERTY配列の切り替え対応
- **VSCode統合**: Neovim拡張との連携機能

#### キーマップ切り替え機能

以下のコマンドを使用してキーマップを切り替えます：

| コマンド | 機能 |
|----------|------|
| `:ToggleKeymap` | 大西配列 ⇔ QWERTY配列のトグル |
| `:KeymapOnishi` | 大西配列に設定 |
| `:KeymapQwerty` | QWERTY配列に設定 |
| `:KeymapStatus` | 現在の配列状態を表示 |

設定は自動的に保存され、次回起動時に復元されます。

### Zsh
- **プラグイン管理**: Sheldon
- **プロンプト**: Powerlevel10k
- **主要プラグイン**: 
  - zsh-autosuggestions（自動補完）
  - zsh-syntax-highlighting（シンタックスハイライト）
  - zsh-z（ディレクトリジャンプ）
  - fzf（ファジーファインダー）

### Tmux
- **キーマッピング**: Neovimと統一（k=左、t=下、n=上、s=右）
- **テーマ**: nordfox
- **XDG対応**: `~/.config/tmux/`に設定配置

### Claude Code
- **Discord通知**: Stop/Notificationイベント時の自動通知
- **Hooks設定**: 新フォーマット対応の自動設定システム
- **セットアップスクリプト**: Discord Webhook URL設定 + hooks自動設定
- **冪等性保証**: 既存hooks設定の保護・重複実行安全性
- **インタラクティブテスト**: セットアップ時の通知動作確認

#### Discord通知設定
1. `~/.claude/scripts/setup-discord.sh`を実行
2. Discord ServerでWebhook URLを作成・入力
3. **hooks設定が自動で構成される**（既存設定は保護）
4. **セットアップ時にテスト通知を実行可能**
5. Claude Code停止時・通知時に自動でDiscordに通知

**特徴**:
- **新hooks フォーマット対応**: Claude Code最新版の設定構造に対応
- **環境非依存**: ハードコードパスを排除し任意の環境で動作
- **安全な設定更新**: 他のhooks設定を上書きせずに部分更新

### その他
- **日本語IME**: zenhan/im-selectによる自動切り替え（macOS）
- **WSL2対応**: クリップボード統合とWindows連携機能

## カスタマイズ

### Neovimキーマップのカスタマイズ

#### 新しいキーマップの追加
通常のキーマップを追加する場合は、各配列ファイルに設定を追加してください：

```lua
-- ~/.config/nvim/lua/config/keymaps/onishi.lua または qwerty.lua
local onishi_config = {
  -- 新しいキーマップを追加
  normal = {
    ['n'] = 'up',
    ['t'] = 'down',
    -- 新しいマッピングをここに追加
    ['<leader>f'] = 'find_files',
  },
  -- ...
}
```

#### 配列に依存しないキーマップの追加
両配列で共通のキーマップは `keymaps.lua` に直接追加してください：

```lua
-- ~/.config/nvim/lua/config/keymaps.lua
-- 起動時の初期化の後に追加
vim.keymap.set('n', '<leader>w', ':w<CR>', { silent = true })
```

#### 新しい配列の追加
1. `keymaps/` ディレクトリに新しいファイルを作成
2. 設定テーブルを定義
3. `keymaps.lua` で新しい配列を登録

```lua
-- 例: ~/.config/nvim/lua/config/keymaps/dvorak.lua
local common = require('config.keymaps.common')
local vscode = require('config.keymaps.vscode')

local dvorak_config = {
  -- 設定を定義
}

return {
  setup = function()
    vscode.setup_keymaps(dvorak_config)
    common.setup_neovim_keymaps(dvorak_config)
  end,
  clear = function()
    -- キーの削除
  end
}
```

#### Neovimプラグインの追加

プラグインの追加方法は、設定の複雑さに応じて以下の2つの方法から選択してください：

##### 設定が必要なプラグイン
複雑な設定が必要なプラグインは個別ファイルで管理してください：

1. `lua/plugins/` ディレクトリに新しいファイルを作成
2. プラグイン設定を記述
3. `lua/config/lazy.lua` にimportを追加

```lua
-- 例: lua/plugins/lualine.lua
return {
  "nvim-lualine/lualine.nvim",
  config = function()
    require('lualine').setup({
      options = {
        theme = 'nordfox',
      },
    })
  end,
}
```

```lua
-- lua/config/lazy.lua に追加
require("lazy").setup({
  spec = {
    { import = "plugins.nightfox" },
    { import = "plugins.lualine" },  -- 新しいプラグインを追加
  }
})
```

##### 設定が不要なプラグイン
設定が不要なプラグインは `lazy.lua` に直接追加してください：

```lua
-- lua/config/lazy.lua
require("lazy").setup({
  spec = {
    -- 設定が必要なプラグイン（個別ファイル）
    { import = "plugins.nightfox" },
    { import = "plugins.lualine" },
    
    -- 設定が不要なプラグイン（直接追加）
    { "vim-jp/vimdoc-ja" },
    { "tpope/vim-sleuth" },
    { "nvim-tree/nvim-web-devicons" },
  }
})
```

または、複数の軽量プラグインをまとめた専用ファイルを作成することも可能です：

```lua
-- lua/plugins/simple.lua
return {
  { "vim-jp/vimdoc-ja" },
  { "tpope/vim-sleuth" },
  { "nvim-tree/nvim-web-devicons" },
}
```

### ローカル設定
各ツールのローカル設定用ファイルを作成してください：

```bash
# Zsh
~/.config/zsh/.zshrc.local

# Neovim  
~/.config/nvim/lua/config/local.lua

# Tmux
~/.config/tmux/local.conf
```

### 環境固有設定
WSL2環境では以下の追加設定スクリプトを実行してください：
```bash
./bin/setup-wsl2.sh
```

## トラブルシューティング

### バックアップの復元
```bash
# バックアップファイルの確認
ls ~/.dotbackup/

# 特定ファイルの復元例
mv ~/.dotbackup/nvim.20240101_120000 ~/.config/nvim
```

### リンクの確認
```bash
# シンボリックリンクの状態確認
ls -la ~/.config/nvim ~/.config/zsh ~/.config/tmux
```

### 再インストール
```bash
# 強制的に再インストール（確認なし）
./bin/install.sh --force
```

## アンインストール

```bash
# シンボリックリンクを削除
rm ~/.config/nvim ~/.config/zsh ~/.config/tmux ~/.config/sheldon ~/.config/p10k

# macOSの場合
rm -rf ~/Library/Application\ Support/com.mitchellh.ghostty

# バックアップから復元
mv ~/.dotbackup/* ~/.config/
```

## ライセンス

MIT License
