#!/usr/bin/env bash

link_to_homedir() {
  echo "Installing dotfiles..."

  # バックアップ先ディレクトリ
  local backup_dir="$HOME/.dotbackup"
  if [ ! -d "$backup_dir" ]; then
    echo "$backup_dir not found. Creating it..."
    mkdir -p "$backup_dir"
  fi

  # 実行スクリプトのディレクトリとdotfilesルート
  local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
  local dotdir="$(dirname "$script_dir")"

  # ソース → リンク先のマッピング定義
  declare -A links=(
    # TODO: ghosttyはwsl2では不要
    ["$dotdir/ghostty"]="$HOME/Library/Application Support/com.mitchellh.ghostty"
    ["$dotdir/nvim"]="$HOME/.config/nvim"
    ["$dotdir/sheldon"]="$HOME/.config/sheldon"
    ["$dotdir/tmux/.tmux.conf"]="$HOME/.tmux.conf"
    ["$dotdir/zsh/.zshrc"]="$HOME/.zshrc"
  )

  for src in "${!links[@]}"; do
    dest="${links[$src]}"
    dest_dir="$(dirname "$dest")"

    echo "Processing: $src → $dest"

    # 既存ファイル/リンクがあればバックアップまたは削除
    if [ -L "$dest" ]; then
      echo "  Removing existing symlink at $dest"
      rm -f "$dest"
    elif [ -e "$dest" ]; then
      # TODO:ホームディレクトリ直下をさしているときにdistがそのディレクトリ自身になっているためmvが失敗する
      echo "  Backing up $dest to $backup_dir"
      mv -f "$dest" "$backup_dir/"
    fi

    # 親ディレクトリを作成
    if [ ! -d "$dest_dir" ]; then
      echo "  Creating parent directory: $dest_dir"
      mkdir -p "$dest_dir"
    fi

    # シンボリックリンク作成
    echo "  Linking $src → $dest"
    ln -snf "$src" "$dest"
  done

  echo "✅ Installation complete!"
}

link_to_homedir
