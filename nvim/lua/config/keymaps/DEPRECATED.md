# 非推奨ファイル一覧

以下のファイルは新しいプラグイン化アーキテクチャ（v2.0）では非推奨となりました。
互換性のために残されていますが、将来のバージョンで削除される予定です。

## 非推奨ファイル

### core.lua
- **置き換え先**: `plugin/core.lua`
- **理由**: プラグイン化に向けた機能分離
- **移行方法**: `require('config.keymaps.plugin.core')` を使用

### onishi.lua
- **置き換え先**: `layouts/onishi.lua`
- **理由**: 純粋な配列定義とロジックの分離
- **移行方法**: 配列定義は `layouts/onishi.lua`、設定ロジックは `plugin/layout-engine.lua` に移行

### qwerty.lua
- **置き換え先**: `layouts/qwerty.lua`
- **理由**: 純粋な配列定義とロジックの分離
- **移行方法**: 配列定義は `layouts/qwerty.lua`、設定ロジックは `plugin/layout-engine.lua` に移行

### user-config.lua
- **置き換え先**: `config/user.lua`
- **理由**: 設定階層の明確化（デフォルト設定との分離）
- **移行方法**: `require('config.keymaps.config.user')` を使用

## 新しいアーキテクチャ

```
keymaps/
├── plugin/          # プラグイン本体
│   ├── core.lua     # コア機能
│   ├── keymap-api.lua # ユーザー向けAPI
│   └── layout-engine.lua # 配列切り替えエンジン
├── layouts/         # 配列定義
│   ├── init.lua     # 配列ローダー
│   ├── onishi.lua   # 大西配列定義
│   └── qwerty.lua   # QWERTY配列定義
├── config/          # 設定管理
│   ├── default.lua  # デフォルト設定
│   └── user.lua     # ユーザー設定
├── keymaps.lua      # メインエントリーポイント
├── keymap-manager.lua # 互換性レイヤー
├── layout-manager.lua # 互換性レイヤー
├── common.lua       # 共通ユーティリティ
├── vscode.lua       # VSCode統合
└── config-schema.lua # 設定バリデーション
```

## 移行スケジュール

- **v2.0**: 新アーキテクチャ導入、旧ファイルは非推奨マーク
- **v2.1**: 旧ファイルから新ファイルへの自動移行警告
- **v3.0**: 旧ファイル削除（破綻的変更）

## 今すぐ移行する場合

新しいアーキテクチャを使用したい場合は、以下のファイルを削除できます：

```bash
rm nvim/lua/config/keymaps/core.lua
rm nvim/lua/config/keymaps/onishi.lua
rm nvim/lua/config/keymaps/qwerty.lua
rm nvim/lua/config/keymaps/user-config.lua
```

ただし、既存のコードが動作しなくなる可能性があるため、十分なテストを行ってください。