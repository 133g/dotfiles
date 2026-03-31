#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
dotdir="$(dirname "$script_dir")"

windowsUserProfile=/mnt/c/Users/$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')
dest="${windowsUserProfile}/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"

if [ ! -d "$(dirname "$dest")" ]; then
  echo "[ERROR] Windows Terminal のディレクトリが見つかりません: $(dirname "$dest")"
  exit 1
fi

cp "$dotdir/windows-terminal/settings.json" "$dest"
echo "[SUCCESS] Windows Terminal の設定をインストールしました"
