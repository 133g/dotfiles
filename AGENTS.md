# AGENTS.md

このリポジトリは macOS / WSL2 (Ubuntu) / Linux に対応した個人用 dotfiles です。

## プロジェクト構造

```
dotfiles/
├── bin/                    # インストール・ユーティリティスクリプト
├── ghostty/config          # Ghosttyターミナル設定（macOSのみ）
├── lazygit/config.yml      # Lazygit設定
├── nvim/                   # Neovim設定（VSCode Neovim拡張にも対応）
│   ├── init.lua            # エントリポイント（vim.g.vscodeで環境分岐）
│   ├── lua/config/         # コア設定（lazy.lua, lsp.lua, wsl.lua, ime.lua）
│   └── lua/plugins/        # lazy.nvimプラグイン定義（1プラグイン1ファイル）
├── p10k/                   # Powerlevel10kテーマ設定
├── sheldon/plugins.toml    # Zshプラグインマネージャ設定
├── tmux/                   # tmux設定
│   ├── tmux.conf           # メイン設定
│   └── tmux-wsl2.conf      # WSL2固有設定（条件付きsource-file）
├── windows-terminal/       # Windows Terminal設定
└── zsh/.zshrc              # Zsh設定
```

## 設計原則

### XDG Base Directory 準拠
すべての設定は `~/.config/` 以下にシンボリックリンクで配置される。`~/.zshenv` が `ZDOTDIR` を設定し、zsh が `$ZDOTDIR/.zshrc` を読み込む。

### OS固有設定の分離
- **OS検出**: `bin/install.sh` の `detect_os()` 関数で `macos` / `wsl2` / `linux` を判定
- **WSL2固有設定**: 専用ファイルに分離し、条件付きで読み込む（例: `tmux/tmux-wsl2.conf`、`nvim/lua/config/wsl.lua`）
- **macOS固有設定**: `ghostty/` は macOS のみリンク。`.zshrc` 内の OS 分岐で Homebrew/mise パスを設定
- **原則**: ソースファイルを動的に書き換えない。OS分岐は `if-shell` や `vim.fn.has()` で条件付き読み込みする

### エディタ環境の分離（Neovim / VSCode）
`nvim/init.lua` で `vim.g.vscode` により分岐：
- **VSCode**: キーマップのみ読み込み（プラグイン・LSP・UI設定はスキップ）
- **Neovim**: 全設定を読み込み（lazy.nvim, LSP, colorscheme 等）
- **共通**: クリップボード設定（`config/wsl.lua`）、キーレイアウト設定

### キーマッピング（大西配列）
カーソル移動を `k=左, t=下, n=上, s=右` に統一。Neovim、tmux (copy-mode-vi)、lazygit で一貫して適用。`USE_LAYOUT` 変数で標準配列への切替も可能。

## コーディング規約

### シェルスクリプト
- shebang: `#!/usr/bin/env bash`
- 必ず `set -euo pipefail` を先頭に記述
- スクリプトのパスはハードコードせず `BASH_SOURCE[0]` から動的に検出
- 色付きメッセージ: `print_info`, `print_success`, `print_warning`, `print_error` 関数を使用
- コメントは日本語で記述

### Neovimプラグイン
- `lua/plugins/` 配下に1プラグイン1ファイルで配置
- `lazy.lua` の `{ import = "plugins" }` でディレクトリごと自動読み込み
- カラーテーマ: **Catppuccin Macchiato**（Ghostty, tmux, Windows Terminal と統一）

### .gitignore
- allowlist方式: デフォルトで全ファイルを無視し、管理対象のみ `!` で明示的に許可
- 新しいディレクトリ/ファイルを追加する場合は `.gitignore` への許可ルール追加が必要

## インストール

```bash
git clone https://github.com/133g/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./bin/install.sh          # シンボリックリンク作成 + ~/.zshenv 生成
./bin/install.sh --force  # 確認プロンプトをスキップ
```

WSL2 では `bin/setup-wsl2.sh` が自動実行される。Windows Terminal の設定は `bin/install_windows_terminal.sh` で別途適用。

## 変更時の注意

- シェルスクリプト変更後: `bash -n <file>` で構文チェック
- `.zshrc` 変更後: `zsh -n zsh/.zshrc` で構文チェック
- Neovimプラグイン追加/削除後: Neovim 起動時に `:Lazy sync` を実行
- 新ファイル追加時: `.gitignore` の allowlist に追加が必要
