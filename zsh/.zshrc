export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:/opt/homebrew/bin

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose  # または quiet
eval "$(SHELDON_LOG=error sheldon source)"       # 出力を suppress

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
alias la='ls -la'
alias ll='ls -lG'

# clearコマンドのalias関連
alias c='clear'
alias cc='c &&'

# neovimコマンドのalias関連
alias vi="nvim"
alias vim="nvim"
alias view="nvim -R"

# To customize prompt, run `p10k configure` or edit ~/.config/p10k/p10k.zsh.
[[ ! -f "${XDG_CONFIG_HOME}/p10k/p10k.zsh" ]] || source "${XDG_CONFIG_HOME}/p10k/p10k.zsh"

# setting for linux(WSL)
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

# XDG Base Directory対応
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"

# tmux XDG対応 - 設定ファイルパスを指定
alias tmux='tmux -f "${XDG_CONFIG_HOME}/tmux/tmux.conf"'

# To customize prompt, run `p10k configure` or edit ~/.config/p10k/p10k.zsh.
[[ ! -f ~/.config/p10k/p10k.zsh ]] || source ~/.config/p10k/p10k.zsh
