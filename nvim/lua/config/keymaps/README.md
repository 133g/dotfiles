# キーマップ設定

シンプルなキーマップ設定です。

## 使用方法

### キーボード配列の設定

`keymaps.lua` の最初の方にある `USE_LAYOUT` 変数を編集してください：

```lua
-- 'onishi' または 'qwerty' を設定
local USE_LAYOUT = 'onishi'
```

- `'onishi'` : 大西配列
- `'qwerty'` : QWERTY配列（標準）

### 大西配列のキーマップ

大西配列では以下のキーマップが適用されます：

- `k` → `h` (左移動)
- `t` → `j` (下移動) 
- `n` → `k` (上移動)
- `s` → `l` (右移動)

元のキーの機能は以下に移動されます：

- `h` → `t` (till文字)
- `j` → `n` (next検索)
- `l` → `s` (substitute)

### 衝突解決

大西配列では `<C-w>s` (水平分割) が右移動キーと衝突するため、`<C-w>\` で水平分割を行えます。

## 基本的なキーマップ

- `<leader>w` : ファイル保存
- `<leader>q` : 終了
- `<leader>x` : 保存して終了
- `<leader>bd` : バッファ削除
- `<leader>bn` : 次のバッファ
- `<leader>bp` : 前のバッファ
- `<leader>sv` : 垂直分割
- `<leader>sh` : 水平分割
- `<leader>to` : 新しいタブ
- `<leader>tx` : タブを閉じる