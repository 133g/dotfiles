# dotfiles

macOS、Linux、WSL2 に対応した個人用 dotfiles。XDG Base Directory 仕様準拠で、大西配列による統一キーマッピング（k=左、t=下、n=上、s=右）を全ツールで採用しています。

## 特徴

- **マルチプラットフォーム**: macOS / Linux / WSL2 (Ubuntu) を自動検出してインストール
- **XDG Base Directory 準拠**: すべての設定を `~/.config/` 以下に統一配置
- **統一キーマッピング**: Neovim・tmux・Lazygit で一貫した大西配列キーバインド
- **VSCode 対応**: VSCode Neovim 拡張でも同じキーマップが使える
- **安全なインストール**: 既存ファイルを自動バックアップしてからシンボリックリンクを作成

## インストール

### 前提条件

| ツール | 用途 | インストール例 |
|--------|------|----------------|
| Git | リポジトリのクローン | — |
| Zsh | デフォルトシェル | `chsh -s $(which zsh)` |
| [Neovim](https://neovim.io/) | エディタ | `brew install neovim` |
| [tmux](https://github.com/tmux/tmux) | ターミナルマルチプレクサ | `brew install tmux` |
| [Sheldon](https://github.com/rossmacarthur/sheldon) | Zsh プラグインマネージャ | `brew install sheldon` |
| [mise](https://mise.jdx.dev/) | ランタイムバージョン管理 | `brew install mise` |
| [Homebrew](https://brew.sh/) | パッケージマネージャ | macOS / Linux 両対応 |
| [Lazygit](https://github.com/jesseduffield/lazygit) | Git TUI | `brew install lazygit` |
| [Ghostty](https://ghostty.org/) | ターミナル（macOS のみ） | — |

### クイックスタート

```bash
git clone https://github.com/133g/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./bin/install.sh
```

インストールスクリプトが自動的に以下を実行します：

1. OS 環境を検出（macOS / WSL2 / Linux）
2. 既存ファイルを `~/.dotbackup/` にバックアップ
3. `~/.config/` 以下にシンボリックリンクを作成
4. Zsh 用ブートストラップファイル（`~/.zshenv`）を生成
5. WSL2 環境では追加設定（`setup-wsl2.sh`）を自動実行

確認プロンプトをスキップする場合は `--force` オプションを使用してください：

```bash
./bin/install.sh --force
```

### インストールされるシンボリックリンク

| ソース | リンク先 | 説明 |
|--------|----------|------|
| `nvim/` | `~/.config/nvim/` | Neovim 設定 |
| `zsh/` | `~/.config/zsh/` | Zsh 設定 |
| `tmux/` | `~/.config/tmux/` | tmux 設定 |
| `sheldon/` | `~/.config/sheldon/` | Zsh プラグイン管理 |
| `p10k/` | `~/.config/p10k/` | Powerlevel10k テーマ |
| `lazygit/` | `~/.config/lazygit/` | Lazygit 設定 |
| `ghostty/`* | `~/Library/Application Support/com.mitchellh.ghostty` | Ghostty 設定（macOS のみ） |

### Windows Terminal（WSL2 環境のみ）

Windows Terminal の設定は自動リンクの対象外です。手動でコピーしてください：

```bash
# dotfiles → Windows Terminal に反映
./bin/install_windows_terminal.sh

# Windows Terminal → dotfiles に取り込み
./bin/update_setting_windows_terminal.sh
```

## 含まれるツール設定

### Neovim

- **プラグイン管理**: [lazy.nvim](https://github.com/folke/lazy.nvim)
- **カラーテーマ**: Catppuccin Macchiato
- **キーマッピング**: 大西配列（`init.lua` の `USE_LAYOUT` 変数で標準配列に切替可能）
- **VSCode 対応**: VSCode Neovim 拡張使用時はキーマップのみ読み込み、プラグイン・LSP はスキップ

### Zsh

- **プラグイン管理**: [Sheldon](https://github.com/rossmacarthur/sheldon)
- **プロンプト**: [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- **主要プラグイン**:
  - zsh-autosuggestions（入力補完サジェスト）
  - zsh-syntax-highlighting（コマンドのシンタックスハイライト）
  - zsh-z（頻用ディレクトリへのジャンプ）
  - fzf（ファジーファインダー）

### tmux

- **テーマ**: Catppuccin Macchiato（Neovim・Ghostty と統一）
- **キーマッピング**: Neovim と統一した大西配列（copy-mode-vi）
- **WSL2 対応**: クリップボード統合（win32yank.exe）を条件付きで自動読み込み

### Lazygit

- 大西配列に合わせたキーバインド（`t`=次の項目、`n`=前の項目）

### Ghostty（macOS のみ）

- テーマ: Catppuccin Macchiato
- フォント: Hack Nerd Font Mono
- 半透明背景（opacity: 0.9）

## カスタマイズ

### Neovim プラグインの追加

`nvim/lua/plugins/` ディレクトリにファイルを追加するだけで自動的に読み込まれます。`lazy.lua` の編集は不要です。

```lua
-- 例: nvim/lua/plugins/my-plugin.lua
return {
  "author/my-plugin.nvim",
  config = function()
    require("my-plugin").setup({})
  end,
}
```

追加後、Neovim を起動すれば lazy.nvim が自動でインストールします。

### キーレイアウトの切替

`nvim/init.lua` の `USE_LAYOUT` 変数を変更してください：

```lua
local USE_LAYOUT = "onishi"  -- 大西配列
-- local USE_LAYOUT = ""     -- 標準配列（hjkl）
```

### その他

各ツールの設定ファイルはそれぞれのディレクトリ（`zsh/`、`tmux/`、`ghostty/` など）に格納されています。直接編集してカスタマイズしてください。

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
ls -la ~/.config/nvim ~/.config/zsh ~/.config/tmux ~/.config/lazygit
```

### 再インストール

```bash
./bin/install.sh --force
```

## アンインストール

```bash
# シンボリックリンクを削除
rm ~/.config/nvim ~/.config/zsh ~/.config/tmux ~/.config/sheldon ~/.config/p10k ~/.config/lazygit

# macOS の場合は Ghostty 設定も削除
rm -rf ~/Library/Application\ Support/com.mitchellh.ghostty

# バックアップから復元
mv ~/.dotbackup/* ~/.config/
```

## ライセンス

MIT License
