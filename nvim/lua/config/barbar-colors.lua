-- barbar.nvimのNordFox色設定
local M = {}

function M.setup()
  -- NordFoxテーマの色パレットを取得
  local ok, palette = pcall(require, 'nightfox.palette')
  if not ok then
    return
  end
  
  local nordfox = palette.load("nordfox")
  
  -- タブの状態別設定を定義
  local buffer_states = {
    Current = {
      bg = nordfox.bg1,
      fg_default = nordfox.fg1,
      fg_dim = nordfox.fg1,
      bold = true,
      colors = {
        red = nordfox.red.base,
        cyan = nordfox.cyan.base,
        blue = nordfox.blue.base,
        yellow = nordfox.yellow.base,
        orange = nordfox.orange.base,
        magenta = nordfox.magenta.base,
        green = nordfox.green.base,
      }
    },
    Inactive = {
      bg = nordfox.bg0,
      fg_default = nordfox.fg3,
      fg_dim = nordfox.fg3,
      bold = false,
      colors = {
        red = nordfox.red.dim,
        cyan = nordfox.cyan.dim,
        blue = nordfox.blue.dim,
        yellow = nordfox.yellow.dim,
        orange = nordfox.orange.dim,
        magenta = nordfox.magenta.dim,
        green = nordfox.green.dim,
      }
    },
    Visible = {
      bg = nordfox.sel0,
      fg_default = nordfox.fg2,
      fg_dim = nordfox.fg2,
      bold = false,
      colors = {
        red = nordfox.red.base,
        cyan = nordfox.cyan.base,
        blue = nordfox.blue.base,
        yellow = nordfox.yellow.base,
        orange = nordfox.orange.base,
        magenta = nordfox.magenta.base,
        green = nordfox.green.base,
      }
    }
  }
  
  -- NordFoxテーマに適合するタブの色設定
  local highlights = {}
  
  -- 各状態に対するハイライト設定を生成
  for state, config in pairs(buffer_states) do
    local prefix = "Buffer" .. state
    
    highlights[prefix] = { fg = config.fg_default, bg = config.bg, bold = config.bold }
    highlights[prefix .. "ERROR"] = { fg = config.colors.red, bg = config.bg }
    highlights[prefix .. "HINT"] = { fg = config.colors.cyan, bg = config.bg }
    highlights[prefix .. "INFO"] = { fg = config.colors.blue, bg = config.bg }
    highlights[prefix .. "WARN"] = { fg = config.colors.yellow, bg = config.bg }
    highlights[prefix .. "Index"] = { fg = config.colors.blue, bg = config.bg, bold = config.bold }
    highlights[prefix .. "Mod"] = { fg = config.colors.orange, bg = config.bg, bold = config.bold }
    highlights[prefix .. "Sign"] = { fg = (state == "Current") and config.colors.blue or config.fg_default, bg = config.bg }
    highlights[prefix .. "Target"] = { fg = config.colors.red, bg = config.bg, bold = config.bold }
    highlights[prefix .. "Icon"] = { fg = config.fg_default, bg = config.bg }
    highlights[prefix .. "Button"] = { fg = config.colors.red, bg = config.bg }
    highlights[prefix .. "Pin"] = { fg = config.colors.magenta, bg = config.bg }
    highlights[prefix .. "Separator"] = { fg = nordfox.bg0, bg = config.bg }
    
    -- Git statusアイコンの背景色設定
    highlights[prefix .. "Added"] = { fg = config.colors.green, bg = config.bg }
    highlights[prefix .. "Changed"] = { fg = config.colors.orange, bg = config.bg }
    highlights[prefix .. "Deleted"] = { fg = config.colors.red, bg = config.bg }
  end
  
  -- タブライン本体
  highlights.BufferTabpages = { fg = nordfox.fg3, bg = nordfox.bg0, bold = true }
  highlights.BufferTabpageFill = { fg = nordfox.fg3, bg = nordfox.bg0 }
  highlights.BufferOffset = { fg = nordfox.fg3, bg = nordfox.bg0 }
  
  -- ハイライトグループを設定
  for group, opts in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, opts)
  end
  
  -- nvim-web-deviconsのアイコンにも背景色を適用
  local web_devicons_ok, web_devicons = pcall(require, 'nvim-web-devicons')
  if web_devicons_ok then
    local icons = web_devicons.get_icons()
    for _, icon_data in pairs(icons) do
      if icon_data.name then
        local name = icon_data.name
        -- 各状態に対してアイコンの背景色を設定
        for state, config in pairs(buffer_states) do
          vim.api.nvim_set_hl(0, 'Buffer' .. state .. name, {
            fg = icon_data.color or config.fg_default,
            bg = config.bg
          })
        end
      end
    end
  end
end

-- オートコマンドでColorSchemeとVimEnterイベント時に色設定を適用
vim.api.nvim_create_autocmd({"ColorScheme", "VimEnter"}, {
  pattern = "*",
  callback = function()
    vim.schedule(function()
      M.setup()
    end)
  end,
})

return M