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
├── nvim/           # Neovim設定（lazy.nvim + nordfox）
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
| `ghostty/`* | `~/Library/Application Support/com.mitchellh.ghostty` | Ghostty設定（macOSのみ） |

*macOSでのみ作成されます

## 主要ツール設定

### Neovim
- **プラグイン管理**: lazy.nvim
- **カラーテーマ**: nordfox
- **キーマッピング**: k=左、t=下、n=上、s=右
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

### その他
- **日本語IME**: zenhan/im-selectによる自動切り替え（macOS）
- **WSL2対応**: クリップボード統合とWindows連携機能

## カスタマイズ

### ローカル設定
各ツールのローカル設定用ファイルを作成できます：

```bash
# Zsh
~/.config/zsh/.zshrc.local

# Neovim  
~/.config/nvim/lua/config/local.lua

# Tmux
~/.config/tmux/local.conf
```

### 環境固有設定
WSL2環境では追加の設定スクリプトが実行されます：
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
