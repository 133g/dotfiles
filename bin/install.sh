#!/usr/bin/env bash

# エラー時にスクリプトを停止
set -euo pipefail

# 色付きメッセージ用の関数
print_info() { echo -e "\033[1;34m[INFO]\033[0m $1"; }
print_success() { echo -e "\033[1;32m[SUCCESS]\033[0m $1"; }
print_warning() { echo -e "\033[1;33m[WARNING]\033[0m $1"; }
print_error() { echo -e "\033[1;31m[ERROR]\033[0m $1"; }

# OS/環境検出
detect_os() {
  case "$(uname -s)" in
    Darwin*) echo "macos" ;;
    Linux*)
      # WSL2環境の検出
      if [ -f "/proc/version" ] && grep -qi "microsoft" "/proc/version"; then
        echo "wsl2"
      else
        echo "linux"
      fi
      ;;
    *)       echo "unknown" ;;
  esac
}

# バックアップファイル名を生成（タイムスタンプ付き）
generate_backup_name() {
  local file="$1"
  local timestamp=$(date "+%Y%m%d_%H%M%S")
  local basename=$(basename "$file")
  echo "${basename}.${timestamp}"
}

# 確認プロンプト
confirm() {
  local message="$1"
  echo -n "$message [y/N]: "
  read -r response
  case "$response" in
    [yY][eE][sS]|[yY]) return 0 ;;
    *) return 1 ;;
  esac
}

link_to_homedir() {
  print_info "dotfilesのインストールを開始します..."

  # OS検出
  local os=$(detect_os)
  print_info "OS: $os"

  # バックアップ先ディレクトリ
  local backup_dir="$HOME/.dotbackup"
  if [ ! -d "$backup_dir" ]; then
    print_info "バックアップディレクトリを作成: $backup_dir"
    if ! mkdir -p "$backup_dir"; then
      print_error "バックアップディレクトリの作成に失敗しました"
      exit 1
    fi
  fi

  # 実行スクリプトのディレクトリとdotfilesルート
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)" || {
    print_error "スクリプトディレクトリの取得に失敗しました"
    exit 1
  }
  local dotdir
  dotdir="$(dirname "$script_dir")" || {
    print_error "dotfilesルートディレクトリの取得に失敗しました"
    exit 1
  }

  print_info "dotfilesディレクトリ: $dotdir"

  # ソース → リンク先のマッピング定義（macOS bash 3.2対応）
  local link_mappings=(
    "$dotdir/nvim:$HOME/.config/nvim"
    "$dotdir/sheldon:$HOME/.config/sheldon"
    "$dotdir/tmux:$HOME/.config/tmux"
    "$dotdir/zsh:$HOME/.config/zsh"
    "$dotdir/p10k:$HOME/.config/p10k"
    "$dotdir/claude:$HOME/.claude"
  )

  # OS/環境固有の設定を追加
  case "$os" in
    "macos")
      link_mappings+=("$dotdir/ghostty:$HOME/Library/Application Support/com.mitchellh.ghostty")
      print_info "macOS固有の設定を追加: Ghostty"
      ;;
    "wsl2")
      print_info "WSL2環境を検出: Ghostty設定をスキップ"
      # WSL2では独自設定があれば追加可能
      # link_mappings+=("$dotdir/wsl2-specific-config:$HOME/.wsl2-config")
      ;;
    "linux")
      print_info "Linux環境を検出: デスクトップ環境向け設定を追加予定"
      # 将来的にLinuxデスクトップ環境固有の設定を追加可能
      ;;
    *)
      print_warning "未知の環境です: $os"
      ;;
  esac

  # リンク処理の前に既存ファイルの確認（冪等性チェック）
  local has_conflicts=false
  local needs_action=false
  
  for mapping in "${link_mappings[@]}"; do
    local src="${mapping%:*}"
    local dest="${mapping#*:}"
    
    # ソースファイル/ディレクトリの存在確認
    if [ ! -e "$src" ]; then
      print_warning "ソースが存在しません: $src"
      continue
    fi

    # 現在の状態をチェック
    if [ -L "$dest" ]; then
      # シンボリックリンクが存在する場合、正しいリンク先かチェック
      local current_target
      current_target="$(readlink "$dest")" || current_target=""
      local expected_target
      expected_target="$(cd "$(dirname "$src")" && pwd -P)/$(basename "$src")" || expected_target="$src"
      
      if [ "$current_target" = "$src" ] || [ "$current_target" = "$expected_target" ]; then
        # 既に正しくリンクされている
        continue
      else
        # 間違ったリンク先
        print_info "既存のシンボリックリンクのリンク先が異なります: $dest -> $current_target (期待値: $src)"
        needs_action=true
      fi
    elif [ -e "$dest" ]; then
      # 通常ファイル/ディレクトリが存在
      print_warning "既存ファイルが見つかりました: $dest"
      has_conflicts=true
      needs_action=true
    else
      # リンク先が存在しない
      needs_action=true
    fi
  done

  # 処理が不要な場合は終了
  if [ "$needs_action" = false ]; then
    print_success "✅ すべてのシンボリックリンクは既に正しく設定されています"
    return 0
  fi

  # 競合がある場合は確認
  if [ "$has_conflicts" = true ]; then
    if ! confirm "既存ファイルをバックアップして続行しますか？"; then
      print_info "インストールをキャンセルしました"
      exit 0
    fi
  fi

  # 実際のリンク処理
  local success_count=0
  local total_count=0
  
  for mapping in "${link_mappings[@]}"; do
    local src="${mapping%:*}"
    local dest="${mapping#*:}"
    local dest_dir
    dest_dir="$(dirname "$dest")"
    
    total_count=$((total_count + 1))

    print_info "処理中: $src → $dest"

    # ソースファイル/ディレクトリの存在確認
    if [ ! -e "$src" ]; then
      print_warning "スキップ: ソースが存在しません"
      continue
    fi

    # 既存ファイル/リンクの処理（冪等性を考慮）
    if [ -L "$dest" ]; then
      # シンボリックリンクが存在する場合、正しいリンク先かチェック
      local current_target
      current_target="$(readlink "$dest")" || current_target=""
      local expected_target
      expected_target="$(cd "$(dirname "$src")" && pwd -P)/$(basename "$src")" || expected_target="$src"
      
      if [ "$current_target" = "$src" ] || [ "$current_target" = "$expected_target" ]; then
        # 既に正しくリンクされている場合はスキップ
        print_success "  既に正しくリンクされています"
        success_count=$((success_count + 1))
        continue
      else
        # 間違ったリンク先の場合は削除
        print_info "  既存のシンボリックリンクを更新: $dest"
        if ! rm -f "$dest"; then
          print_error "  シンボリックリンクの削除に失敗"
          continue
        fi
      fi
    elif [ -e "$dest" ]; then
      local backup_name
      backup_name=$(generate_backup_name "$dest")
      local backup_path="$backup_dir/$backup_name"
      
      print_info "  バックアップ: $dest → $backup_path"
      if ! mv "$dest" "$backup_path"; then
        print_error "  バックアップに失敗"
        continue
      fi
    fi

    # 親ディレクトリを作成
    if [ ! -d "$dest_dir" ]; then
      print_info "  親ディレクトリを作成: $dest_dir"
      if ! mkdir -p "$dest_dir"; then
        print_error "  親ディレクトリの作成に失敗"
        continue
      fi
    fi

    # シンボリックリンク作成
    print_info "  シンボリックリンクを作成: $src → $dest"
    if ln -snf "$src" "$dest"; then
      print_success "  完了"
      success_count=$((success_count + 1))
    else
      print_error "  シンボリックリンクの作成に失敗"
    fi
  done

  echo
  if [ "$success_count" -eq "$total_count" ]; then
    print_success "✅ すべてのファイルのインストールが完了しました ($success_count/$total_count)"
  else
    print_warning "⚠️  インストールが部分的に完了しました ($success_count/$total_count)"
  fi
  
  if [ -d "$backup_dir" ] && [ "$(ls -A "$backup_dir" 2>/dev/null)" ]; then
    print_info "バックアップファイルは $backup_dir に保存されています"
  fi

  # zsh XDG対応ブートストラップファイルの作成
  print_info "zsh XDG対応ブートストラップファイルを作成中..."
  local zshenv_content="# XDG Base Directory準拠のzsh設定
export XDG_CONFIG_HOME=\"\${XDG_CONFIG_HOME:-\$HOME/.config}\"
export ZDOTDIR=\"\${XDG_CONFIG_HOME}/zsh\"
[ -f \"\$ZDOTDIR/.zshrc\" ] && source \"\$ZDOTDIR/.zshrc\""
  
  local zshenv_path="$HOME/.zshenv"
  if [ ! -f "$zshenv_path" ] || ! grep -q "ZDOTDIR" "$zshenv_path"; then
    echo "$zshenv_content" > "$zshenv_path"
    print_success "zshブートストラップファイルを作成: $zshenv_path"
  else
    print_info "zshブートストラップファイルは既に存在します"
  fi

  # Claude設定の初期化
  print_info "Claude設定を初期化中..."
  local claude_config_example="$HOME/.claude/discord-config.json.example"
  local claude_config="$HOME/.claude/discord-config.json"
  
  if [ -f "$claude_config_example" ] && [ ! -f "$claude_config" ]; then
    cp "$claude_config_example" "$claude_config"
    print_success "Claude Discord設定ファイルを作成: $claude_config"
    print_info "Discord通知を使用する場合は、~/.claude/scripts/setup-discord.sh を実行してください"
  elif [ ! -f "$claude_config_example" ]; then
    print_warning "Claude設定のexampleファイルが見つかりません"
  else
    print_info "Claude Discord設定ファイルは既に存在します"
  fi

  # WSL2固有の追加設定
  if [ "$os" = "wsl2" ]; then
    print_info "WSL2環境向けの追加設定を実行します..."
    local wsl2_setup_script="$script_dir/setup-wsl2.sh"
    if [ -f "$wsl2_setup_script" ] && [ -x "$wsl2_setup_script" ]; then
      "$wsl2_setup_script"
    else
      print_warning "WSL2設定スクリプトが見つかりません: $wsl2_setup_script"
    fi
  fi
}

# メイン実行部分
main() {
  # 引数の処理
  while [[ $# -gt 0 ]]; do
    case $1 in
      -h|--help)
        echo "使用法: $0 [オプション]"
        echo "オプション:"
        echo "  -h, --help    このヘルプを表示"
        echo "  -f, --force   確認なしで実行"
        exit 0
        ;;
      -f|--force)
        FORCE=true
        shift
        ;;
      *)
        print_error "不明なオプション: $1"
        exit 1
        ;;
    esac
  done

  link_to_homedir
}

# 直接実行された場合のみmainを呼び出し
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
