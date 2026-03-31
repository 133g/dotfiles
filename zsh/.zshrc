# XDG Base Directory対応
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"

# PATH の重複を自動排除（zsh の path 配列はユニーク保持）
typeset -U path

path+=("$HOME/.local/bin" "$HOME/bin" "$HOME/.local/share/mise/shims")

# WSL2 固有パス
if grep -qi microsoft /proc/version 2>/dev/null; then
  path+=(/mnt/c/zenhan/bin)
fi

if command -v nvim &>/dev/null; then
  export EDITOR=nvim
else
  export EDITOR=vim
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose  # または quiet
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

eval "$(SHELDON_LOG=error sheldon source)"       # 出力を suppress

# viins モードで Ctrl+E が end-of-line を呼ぶように明示的に設定
# (zsh-autosuggestions は end-of-line widget をラップして補完を受け付けるため)
bindkey -M viins '^E' end-of-line

#################################  HISTORY  #################################
# history
HISTFILE=$HOME/.zsh_history     # 履歴を保存するファイル
HISTSIZE=100000                 # メモリ上に保存する履歴のサイズ
SAVEHIST=1000000                # 上述のファイルに保存する履歴のサイズ

# share .zshhistory
setopt inc_append_history       # 実行時に履歴をファイルにに追加していく
setopt share_history            # 履歴を他のシェルとリアルタイム共有する

setopt hist_ignore_all_dups     # ヒストリーに重複を表示しない
setopt hist_save_no_dups        # 重複するコマンドが保存されるとき、古い方を削除する。
setopt extended_history         # コマンドのタイムスタンプをHISTFILEに記録する
setopt hist_expire_dups_first   # HISTFILEのサイズがHISTSIZEを超える場合は、最初に重複を削除します

# ディレクトリ名だけでcdする
setopt auto_cd

# ビープ音を消す
setopt no_beep

# lsコマンドのalias関連
alias ls='ls -F'
alias la='ls -la'
alias ll='ls -lG'

# clearコマンドのalias関連
alias c='clear'
alias cc='c &&'

# neovimコマンドのalias関連
if command -v nvim &>/dev/null; then
  alias vi="nvim"
  alias vim="nvim"
  alias view="nvim -R"
else
  alias view="vim -R"
fi

# To customize prompt, run `p10k configure` or edit ~/.config/p10k/p10k.zsh.
[[ ! -f "${XDG_CONFIG_HOME}/p10k/p10k.zsh" ]] || source "${XDG_CONFIG_HOME}/p10k/p10k.zsh"

# setting for Linux (WSL2含む)
if [[ "$(uname)" == "Linux" ]]; then
  # Homebrewのパスを動的に検出
  local brew_path="/home/linuxbrew/.linuxbrew/bin/brew"
  if [[ -x "$brew_path" ]]; then
    eval "$($brew_path shellenv)"
  fi
  
  # miseのパスを動的に検出
  local mise_path="/home/linuxbrew/.linuxbrew/bin/mise"
  if [[ -x "$mise_path" ]]; then
    eval "$($mise_path activate zsh)"
  fi
fi

# setting for macOS
if [[ "$(uname)" == "Darwin" ]]; then
  eval "$(/opt/homebrew/bin/mise activate zsh)"
fi

# tmux XDG対応 - 設定ファイルパスを指定
alias tmux='tmux -f "${XDG_CONFIG_HOME}/tmux/tmux.conf"'


