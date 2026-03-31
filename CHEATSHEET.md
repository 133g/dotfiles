# チートシート

このdotfilesで設定されている全キーバインド・エイリアス・設定のクイックリファレンス。

> **大西配列**: カーソル移動は `k=←` `t=↓` `n=↑` `s=→`（全ツール共通）

---

## Neovim

**Leader**: `Space`　|　**テーマ**: Catppuccin Macchiato　|　**レイアウト**: 大西配列

### カーソル移動（大西配列）

| キー | 動作 | 元のキー |
|------|------|----------|
| `k` | ← 左 | `h` |
| `t` | ↓ 下（表示行） | `gj` |
| `n` | ↑ 上（表示行） | `gk` |
| `s` | → 右 | `l` |
| `j` | 次の検索結果 | `n` |
| `l` | 置換（substitute） | `s` |
| `h` | 文字まで移動（till） | `t` |

### ウィンドウ操作

| キー | Neovim | VSCode |
|------|--------|--------|
| `<leader>k` | ウィンドウ左 | navigateLeft |
| `<leader>t` | ウィンドウ下 | navigateDown |
| `<leader>n` | ウィンドウ上 | navigateUp |
| `<leader>s` | ウィンドウ右 | navigateRight |
| `<leader>v` | 縦分割 | splitEditorRight |
| `<leader>l` | 横分割 | splitEditorDown |
| `<leader>c` | 閉じる | — |

### ファイル・バッファ

| キー | 動作 |
|------|------|
| `<leader>w` | 保存 |
| `<leader>q` | 終了 |
| `<leader>bn` | 次のバッファ |
| `<leader>bp` | 前のバッファ |

### 編集

| キー | 動作 |
|------|------|
| `Y` | 行末までヤンク |
| `x` | 削除（レジスタに入れない） |
| `<C-d>` | 半ページ下＋中央揃え |
| `<C-u>` | 半ページ上＋中央揃え |

### LSP（バッファにサーバー接続時のみ有効）

| キー | 動作 |
|------|------|
| `gd` | 定義へジャンプ |
| `<leader>k` | ホバードキュメント |
| `<leader>ca` | コードアクション |
| `<leader>rn` | シンボルリネーム |
| `<leader>e` | 診断情報（フロート） |

有効なLSPサーバー: `lua_ls`, `ts_ls`, `biome`

### プラグインキーマップ

| キー | 動作 | プラグイン |
|------|------|-----------|
| `-` | 親ディレクトリを開く | Oil |
| `_` | カレントディレクトリを開く | Oil |
| `<leader>-` | 親ディレクトリ（フロート） | Oil |
| `<leader>_` | カレントディレクトリ（フロート） | Oil |
| `<leader>lg` | LazyGit を開く | lazygit.nvim |
| `<leader>sm` | Markdown描画トグル | render-markdown |

### Treesitter 選択

| キー | 動作 |
|------|------|
| `gnn` | 選択開始 |
| `grn` | ノード単位で選択拡大 |
| `grc` | スコープ単位で選択拡大 |
| `grm` | 選択縮小 |

### Copilot

ゴーストテキストモード（挿入モードで自動表示）。`Tab` で受け入れ。

### Neovim オプション

```
number + relativenumber    行番号（相対）
cursorline                 カーソル行ハイライト
scrolloff = 10             上下スクロール余白
tabstop/shiftwidth = 2     インデント幅
expandtab                  タブをスペースに
clipboard = unnamedplus    システムクリップボード連携
```

---

## tmux

**テーマ**: Catppuccin Macchiato　|　**Prefix**: `Ctrl+b`（デフォルト）

### 分割・操作

| キー | 動作 |
|------|------|
| `prefix v` | 縦分割 |
| `prefix -` | 横分割 |

### コピーモード（vi キーバインド）

| キー | 動作 |
|------|------|
| `k` | ← 左 |
| `t` | ↓ 下 |
| `n` | ↑ 上 |
| `s` | → 右 |
| `v` | 選択開始 |
| `C-v` | 矩形選択トグル |
| `y` | コピー（WSL2: クリップボードへ） |
| `h` | 次の検索結果 |
| `j` | 前の検索結果 |

### オプション

```
mouse on                   マウス操作有効
escape-time 0              Escキー遅延なし
default-terminal tmux-256color
```

---

## Zsh

**プロンプト**: Powerlevel10k　|　**プラグイン管理**: Sheldon

### エイリアス

| エイリアス | コマンド |
|-----------|---------|
| `ls` | `ls -F` |
| `la` | `ls -la` |
| `ll` | `ls -lG` |
| `c` | `clear` |
| `cc` | `c &&` |
| `vi` / `vim` | `nvim` |
| `view` | `nvim -R` |

### キーバインド

| キー | 動作 |
|------|------|
| `Ctrl+E`（viins） | 行末へ移動（autosuggestions受け入れ） |

### 主要オプション

```
auto_cd              ディレクトリ名だけでcd
share_history        シェル間で履歴共有
hist_ignore_all_dups 重複履歴を非表示
HISTSIZE = 100,000   メモリ上の履歴サイズ
SAVEHIST = 1,000,000 ファイル上の履歴サイズ
EDITOR = nvim
```

### Sheldon プラグイン

| プラグイン | 用途 |
|-----------|------|
| zsh-defer | プラグイン遅延読み込み |
| powerlevel10k | プロンプトテーマ |
| zsh-autosuggestions | 入力補完サジェスト |
| zsh-syntax-highlighting | コマンドハイライト |
| zsh-z | 頻用ディレクトリジャンプ（`z <部分名>`） |
| fzf | ファジーファインダー（`Ctrl+R` で履歴検索） |

---

## Lazygit

| キー | 動作 |
|------|------|
| `t` | 次の項目 |
| `n` | 前の項目 |

---

## Ghostty（macOS のみ）

```
theme       Catppuccin Macchiato
font        Hack Nerd Font Mono, 14pt
opacity     0.9（半透明）
titlebar    非表示
ligatures   無効
```

---

## IME 自動切替

| ツール | 対象OS | 動作 |
|--------|--------|------|
| zenhan | WSL2 / Linux | InsertLeave/CmdlineLeave で IME OFF |
| im-select | macOS | InsertLeave で英数入力に切替 |

---

## クリップボード連携

| 環境 | 方法 |
|------|------|
| macOS | システム標準（`unnamedplus`） |
| WSL2 (Neovim) | `win32yank.exe` |
| WSL2 (tmux) | `win32yank.exe`（コピーモード `y` キー） |

---

## OS別の追加設定

| 項目 | macOS | WSL2 / Linux |
|------|-------|-------------|
| Homebrew | `/opt/homebrew/` | `/home/linuxbrew/` |
| mise | Homebrew 経由 | Linuxbrew 経由 |
| Ghostty | ✅ | — |
| Windows Terminal | — | `bin/install_windows_terminal.sh` |
| zenhan (IME) | — | `/mnt/c/zenhan/bin` |
