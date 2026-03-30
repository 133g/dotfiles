#!/usr/bin/env bash

# WSL2固有の設定を追加するスクリプト
set -euo pipefail

# 色付きメッセージ用の関数
print_info() { echo -e "\033[1;34m[INFO]\033[0m $1"; }
print_success() { echo -e "\033[1;32m[SUCCESS]\033[0m $1"; }
print_warning() { echo -e "\033[1;33m[WARNING]\033[0m $1"; }
print_error() { echo -e "\033[1;31m[ERROR]\033[0m $1"; }

setup_wsl2_configs() {
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
  local dotdir
  dotdir="$(dirname "$script_dir")"

  print_info "WSL2固有の設定を追加します..."

  # tmux設定にWSL2のクリップボード統合を追加
  local tmux_conf="$dotdir/tmux/tmux.conf"
  if [ -f "$tmux_conf" ]; then
    if ! grep -q "win32yank.exe" "$tmux_conf"; then
      print_info "tmux設定にWSL2クリップボード統合を追加"
      cat >> "$tmux_conf" << 'EOF'

# WSL2固有の設定
# クリップボード統合（WSL2でのみ有効）
if-shell 'test -f /proc/version && grep -qi microsoft /proc/version' \
  'bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "win32yank.exe -i"'

EOF
      print_success "WSL2クリップボード統合を追加しました"
    else
      print_info "WSL2クリップボード統合は既に設定済みです"
    fi
  fi

  # nvim のクリップボード設定は nvim/lua/config/wsl.lua で win32yank.exe を使って管理済み

  print_success "✅ WSL2固有の設定が完了しました"
}

# メイン実行
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_wsl2_configs
fi