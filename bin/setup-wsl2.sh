#!/usr/bin/env bash

# WSL2固有の設定を追加するスクリプト
set -euo pipefail

# 共通関数の読み込み
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/lib/utils.sh"

setup_wsl2_configs() {
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
  local dotdir
  dotdir="$(dirname "$script_dir")"

  print_info "WSL2固有の設定を確認します..."

  # tmux WSL2設定ファイルの存在確認
  local tmux_wsl2_conf="$dotdir/tmux/tmux-wsl2.conf"
  if [ -f "$tmux_wsl2_conf" ]; then
    print_success "tmux WSL2設定ファイルが存在します: $tmux_wsl2_conf"
    print_info "tmux.confからsource-fileで自動読み込みされます"
  else
    print_warning "tmux WSL2設定ファイルが見つかりません: $tmux_wsl2_conf"
  fi

  # nvim のクリップボード設定は nvim/lua/config/wsl.lua で win32yank.exe を使って管理済み

  print_success "✅ WSL2固有の設定が完了しました"
}

# メイン実行
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_wsl2_configs
fi