# dotfiles

## 方針

- Windowsのことはいったん考えない

## シンボリックリンクの貼り方

```zsh
mkdir backup && mv ~/.bashrc backup
ln -s ~/dotfiles/.bashrc ~

```

## nvimの設定ファイル配置場所（デフォルト）

```
~/.config/nvim/init.lua

```
