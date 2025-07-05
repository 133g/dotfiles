-- キーマップ設定のスキーマ定義とバリデーション
-- プラグイン化時の設定バリデーションのために使用

local M = {}

-- ユーザー設定のスキーマ定義
M.user_config_schema = {
  leader_keys = {
    type = "table",
    required = true,
    properties = {
      leader = { type = "string", default = " " },
      localleader = { type = "string", default = " " }
    }
  },
  
  basic_keymaps = {
    type = "array",
    items = {
      type = "table",
      properties = {
        logical_key = { type = "string", required = true },
        target = { type = "string", required = true },
        opts = { type = "table", required = false }
      }
    }
  },
  
  leader_keymaps = {
    type = "array",
    items = {
      type = "table",
      properties = {
        key = { type = "string", required = true },
        target = { type = "string", required = true },
        opts = { type = "table", required = false }
      }
    }
  },
  
  local_leader_keymaps = {
    type = "array",
    items = {
      type = "table",
      properties = {
        key = { type = "string", required = true },
        target = { type = "string", required = true },
        opts = { type = "table", required = false }
      }
    }
  },
  
  bulk_keymaps = {
    type = "array",
    items = {
      type = "table",
      properties = {
        mappings = { type = "table", required = true },
        opts = { type = "table", required = false }
      }
    }
  },
  
  filetype_keymaps = {
    type = "table",
    properties = {}  -- 動的なファイルタイプ名
  },
  
  layout_settings = {
    type = "table",
    required = true,
    properties = {
      default_layout = { 
        type = "string", 
        enum = { "onishi", "qwerty" },
        default = "onishi"
      },
      enable_layout_switching = { type = "boolean", default = true }
    }
  },
  
  vscode_settings = {
    type = "table",
    required = true,
    properties = {
      enable_vscode_integration = { type = "boolean", default = true }
    }
  }
}

-- 有効な論理キー名の定義
M.valid_logical_keys = {
  "up", "down", "left", "right",
  "word_left", "word_right",
  "line_start", "line_end"
}

-- 基本的なバリデーション関数
function M.validate_config(config)
  local errors = {}
  
  -- 必須フィールドのチェック
  if not config.leader_keys then
    table.insert(errors, "leader_keys is required")
  end
  
  if not config.layout_settings then
    table.insert(errors, "layout_settings is required")
  end
  
  if not config.vscode_settings then
    table.insert(errors, "vscode_settings is required")
  end
  
  -- basic_keymapsの論理キー名バリデーション
  if config.basic_keymaps then
    for i, keymap in ipairs(config.basic_keymaps) do
      if keymap.logical_key then
        local is_valid = false
        for _, valid_key in ipairs(M.valid_logical_keys) do
          if keymap.logical_key == valid_key then
            is_valid = true
            break
          end
        end
        if not is_valid then
          table.insert(errors, string.format(
            "Invalid logical_key '%s' in basic_keymaps[%d]. Valid keys: %s",
            keymap.logical_key, i, table.concat(M.valid_logical_keys, ", ")
          ))
        end
      end
    end
  end
  
  -- layout_settingsのバリデーション
  if config.layout_settings then
    local valid_layouts = { "onishi", "qwerty" }
    if config.layout_settings.default_layout then
      local is_valid = false
      for _, valid_layout in ipairs(valid_layouts) do
        if config.layout_settings.default_layout == valid_layout then
          is_valid = true
          break
        end
      end
      if not is_valid then
        table.insert(errors, string.format(
          "Invalid default_layout '%s'. Valid layouts: %s",
          config.layout_settings.default_layout,
          table.concat(valid_layouts, ", ")
        ))
      end
    end
  end
  
  return errors
end

-- 設定にデフォルト値を適用する関数
function M.apply_defaults(config)
  config = config or {}
  
  -- leader_keysのデフォルト
  config.leader_keys = config.leader_keys or {}
  config.leader_keys.leader = config.leader_keys.leader or " "
  config.leader_keys.localleader = config.leader_keys.localleader or " "
  
  -- 配列系のデフォルト
  config.basic_keymaps = config.basic_keymaps or {}
  config.leader_keymaps = config.leader_keymaps or {}
  config.local_leader_keymaps = config.local_leader_keymaps or {}
  config.bulk_keymaps = config.bulk_keymaps or {}
  config.filetype_keymaps = config.filetype_keymaps or {}
  
  -- layout_settingsのデフォルト
  config.layout_settings = config.layout_settings or {}
  config.layout_settings.default_layout = config.layout_settings.default_layout or "onishi"
  config.layout_settings.enable_layout_switching = 
    config.layout_settings.enable_layout_switching ~= false  -- デフォルトtrue
  
  -- vscode_settingsのデフォルト
  config.vscode_settings = config.vscode_settings or {}
  config.vscode_settings.enable_vscode_integration = 
    config.vscode_settings.enable_vscode_integration ~= false  -- デフォルトtrue
  
  return config
end

-- 設定のサニタイズ（バリデーション + デフォルト適用）
function M.sanitize_config(config)
  config = M.apply_defaults(config)
  local errors = M.validate_config(config)
  
  if #errors > 0 then
    vim.notify(
      "Keymap configuration errors:\n" .. table.concat(errors, "\n"),
      vim.log.levels.ERROR
    )
  end
  
  return config, errors
end

return M