-- プラグイン情報とエントリーポイント
-- プラグイン化時のメインエントリーファイル

local M = {}

-- プラグイン情報
M.info = {
  name = "logical-keymap",
  version = "2.0.0",
  description = "論理キーマッピングシステム - 配列非依存のキーマップ管理",
  author = "Generated with Claude Code",
  license = "MIT",
  repository = "https://github.com/user/logical-keymap",
  dependencies = {
    nvim = ">=0.8.0"
  },
  supports = {
    vscode_neovim = true,
    various_layouts = true,
    custom_layouts = true
  }
}

-- プラグインAPI
M.api = require('config.keymaps.plugin.keymap-api')

-- 配列エンジン
M.engine = require('config.keymaps.plugin.layout-engine')

-- コア機能
M.core = require('config.keymaps.plugin.core')

-- 配列管理
M.layouts = require('config.keymaps.layouts')

-- 設定管理
M.config = {
  default = require('config.keymaps.config.default'),
  get_user_config = function()
    local ok, user_config = pcall(require, 'config.keymaps.config.user')
    if ok then
      return user_config
    end
    return M.config.default
  end
}

-- プラグインのセットアップ関数（プラグインマネージャー用）
-- @param opts table: ユーザー設定（省略可能）
function M.setup(opts)
  opts = opts or {}
  
  -- デフォルト設定とユーザー設定をマージ
  local config = vim.tbl_deep_extend('force', M.config.default, opts)
  
  -- リーダーキーの設定
  if config.leader_keys then
    vim.g.mapleader = config.leader_keys.leader
    vim.g.maplocalleader = config.leader_keys.localleader
  end
  
  -- コアシステムの初期化
  M.core.init(config.layout_settings or {})
  
  -- 配列エンジンの初期化
  M.engine.init(config.layout_settings or {})
  
  -- ユーザーキーマップの適用
  if config.basic_keymaps then
    for _, keymap in ipairs(config.basic_keymaps) do
      M.api.map(keymap.logical_key, keymap.target, keymap.opts)
    end
  end
  
  if config.leader_keymaps then
    for _, keymap in ipairs(config.leader_keymaps) do
      M.api.map_leader(keymap.key, keymap.target, keymap.opts)
    end
  end
  
  if config.local_leader_keymaps then
    for _, keymap in ipairs(config.local_leader_keymaps) do
      M.api.map_local_leader(keymap.key, keymap.target, keymap.opts)
    end
  end
  
  if config.bulk_keymaps then
    for _, bulk in ipairs(config.bulk_keymaps) do
      M.api.map_bulk(bulk.mappings, bulk.opts)
    end
  end
  
  -- ファイルタイプ固有のキーマップ
  if config.filetype_keymaps then
    for filetype, keymaps in pairs(config.filetype_keymaps) do
      vim.api.nvim_create_autocmd('FileType', {
        pattern = filetype,
        callback = function()
          for _, keymap in ipairs(keymaps) do
            M.api.map_local_leader(keymap.key, keymap.target, 
              vim.tbl_extend('force', keymap.opts or {}, { buffer = true }))
          end
        end,
      })
    end
  end
  
  -- 配列切り替え後のイベント処理
  if config.plugin_settings and config.plugin_settings.enable_autocmds then
    vim.api.nvim_create_autocmd('User', {
      pattern = 'KeymapLayoutChanged',
      callback = function()
        -- ユーザーキーマップの再適用
        if config.basic_keymaps then
          for _, keymap in ipairs(config.basic_keymaps) do
            M.api.map(keymap.logical_key, keymap.target, keymap.opts)
          end
        end
      end,
      desc = 'Reapply user keymaps after layout change'
    })
  end
  
  -- コマンドの登録
  if config.plugin_settings and config.plugin_settings.enable_commands and 
     config.layout_settings and config.layout_settings.enable_layout_switching then
    
    vim.api.nvim_create_user_command('ToggleKeymap', function()
      M.engine.toggle_layout()
    end, {
      desc = 'キーマップ配列を切り替え（大西配列 ⇔ QWERTY配列）'
    })

    vim.api.nvim_create_user_command('KeymapOnishi', function()
      M.engine.set_layout('onishi')
    end, {
      desc = 'キーマップを大西配列に設定'
    })

    vim.api.nvim_create_user_command('KeymapQwerty', function()
      M.engine.set_layout('qwerty')
    end, {
      desc = 'キーマップをQWERTY配列に設定'
    })

    vim.api.nvim_create_user_command('KeymapStatus', function()
      local status = M.engine.get_layout_status()
      print('Keymap: ' .. status.current_display_name)
    end, {
      desc = 'Show current keymap layout'
    })
  end
  
  return true
end

-- プラグインの状態取得
function M.status()
  return {
    plugin_info = M.info,
    current_layout = M.engine.get_current_layout(),
    available_layouts = M.api.get_available_layouts(),
    available_logical_keys = M.api.get_available_keys(),
    engine_status = M.engine.get_layout_status()
  }
end

-- 便利関数のエイリアス
M.map = M.api.map
M.map_leader = M.api.map_leader
M.map_local_leader = M.api.map_local_leader
M.map_bulk = M.api.map_bulk
M.toggle = M.engine.toggle_layout
M.set_layout = M.engine.set_layout
M.get_layout = M.engine.get_current_layout

return M