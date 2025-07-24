# dotfiles

macOS、Linux、WSL2に対応したdotfiles構成。XDG Base Directory仕様準拠で、統一されたキーマッピング（k=左、t=下、n=上、s=右）を全ツールで採用。

## 特徴

- **XDG Base Directory準拠**: すべての設定ファイルを`~/.config/`以下に統一
- **マルチプラットフォーム対応**: macOS、Linux、WSL2を自動検出
- **統一キーマッピング**: Neovim、tmux、シェルで一貫したキーバインド
- **安全なインストール**: 既存ファイルの自動バックアップ

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

## 主要ツール設定

### Neovim

- **プラグイン管理**: lazy.nvim
- **カラーテーマ**: nordfox
- **キーマッピング**: 大西配列（k=左、t=下、n=上、s=右）とQWERTY配列の切り替え対応
- **VSCode統合**: Neovim拡張との連携機能


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

## カスタマイズ

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

### その他のカスタマイズ

各ツール（Zsh、Tmux、Ghosttyなど）の詳細なカスタマイズ方法、ローカル設定ファイルの作成方法、環境固有設定については [CUSTOMIZE.md](CUSTOMIZE.md) を参照してください。

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
