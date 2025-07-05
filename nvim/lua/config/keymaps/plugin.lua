-- プラグイン情報とエントリーポイント
-- Neovim専用論理キーマッピングシステム

local M = {}

-- プラグイン情報
M.info = {
  name = "logical-keymap",
  version = "2.0.0",
  description = "Neovim専用論理キーマッピングシステム - 配列非依存のキーマップ管理",
  author = "Generated with Claude Code",
  license = "MIT",
  repository = "https://github.com/user/logical-keymap",
  dependencies = {
    nvim = ">=0.8.0"
  },
  supports = {
    various_layouts = true,
    custom_layouts = true,
    window_operations = true
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
-- @param opts table: 設定オプション（省略可能）
-- @param opts.default_layout string: デフォルト配列名（'onishi' | 'qwerty'）
-- @param opts.enable_layout_switching boolean: 配列切り替え機能の有効/無効
-- @param opts.enable_commands boolean: コマンド登録の有効/無効
function M.setup(opts)
  opts = opts or {}
  
  -- デフォルト設定
  local config = {
    default_layout = opts.default_layout or 'onishi',
    enable_layout_switching = opts.enable_layout_switching ~= false,
    enable_commands = opts.enable_commands ~= false,
  }
  
  -- コアシステムの初期化
  M.core.init(config)
  
  -- 配列エンジンの初期化
  M.engine.init(config)
  
  -- コマンドの登録
  if config.enable_commands and config.enable_layout_switching then
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

-- 基本API関数のエイリアス
M.map = M.api.map
M.toggle = M.engine.toggle_layout
M.set_layout = M.engine.set_layout
M.get_layout = M.engine.get_current_layout
M.get_available_keys = M.api.get_available_keys

return M