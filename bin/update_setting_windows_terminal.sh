#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
dotdir="$(dirname "$script_dir")"

windowsUserProfile=/mnt/c/Users/$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')
src="${windowsUserProfile}/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"

if [ ! -f "$src" ]; then
  echo "[ERROR] Windows Terminal の設定ファイルが見つかりません: $src"
  exit 1
fi

cp "$src" "$dotdir/windows-terminal/settings.json"
echo "[SUCCESS] Windows Terminal の設定を取得しました"
