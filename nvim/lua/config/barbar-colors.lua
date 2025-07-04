-- barbar.nvimのNordFox色設定
local M = {}

function M.setup()
  -- NordFoxテーマの色パレットを取得
  local ok, palette = pcall(require, 'nightfox.palette')
  if not ok then
    return
  end
  
  local nordfox = palette.load("nordfox")
  
  -- NordFoxテーマに適合するタブの色設定
  local highlights = {
    -- アクティブタブ（現在のバッファ）
    BufferCurrent = { fg = nordfox.fg1, bg = nordfox.bg1, bold = true },
    BufferCurrentERROR = { fg = nordfox.red.base, bg = nordfox.bg1 },
    BufferCurrentHINT = { fg = nordfox.cyan.base, bg = nordfox.bg1 },
    BufferCurrentINFO = { fg = nordfox.blue.base, bg = nordfox.bg1 },
    BufferCurrentWARN = { fg = nordfox.yellow.base, bg = nordfox.bg1 },
    BufferCurrentIndex = { fg = nordfox.blue.base, bg = nordfox.bg1, bold = true },
    BufferCurrentMod = { fg = nordfox.orange.base, bg = nordfox.bg1, bold = true },
    BufferCurrentSign = { fg = nordfox.blue.base, bg = nordfox.bg1 },
    BufferCurrentTarget = { fg = nordfox.red.base, bg = nordfox.bg1, bold = true },
    BufferCurrentIcon = { fg = nordfox.fg1, bg = nordfox.bg1 },
    BufferCurrentButton = { fg = nordfox.red.base, bg = nordfox.bg1 },
    BufferCurrentPin = { fg = nordfox.magenta.base, bg = nordfox.bg1 },
    BufferCurrentSeparator = { fg = nordfox.bg0, bg = nordfox.bg1 },
    
    -- 非アクティブなタブ（より濃い背景色）
    BufferInactive = { fg = nordfox.fg3, bg = nordfox.bg0 },
    BufferInactiveERROR = { fg = nordfox.red.dim, bg = nordfox.bg0 },
    BufferInactiveHINT = { fg = nordfox.cyan.dim, bg = nordfox.bg0 },
    BufferInactiveINFO = { fg = nordfox.blue.dim, bg = nordfox.bg0 },
    BufferInactiveWARN = { fg = nordfox.yellow.dim, bg = nordfox.bg0 },
    BufferInactiveIndex = { fg = nordfox.fg3, bg = nordfox.bg0 },
    BufferInactiveMod = { fg = nordfox.orange.dim, bg = nordfox.bg0 },
    BufferInactiveSign = { fg = nordfox.fg3, bg = nordfox.bg0 },
    BufferInactiveTarget = { fg = nordfox.red.dim, bg = nordfox.bg0 },
    BufferInactiveIcon = { fg = nordfox.fg3, bg = nordfox.bg0 },
    BufferInactiveButton = { fg = nordfox.red.dim, bg = nordfox.bg0 },
    BufferInactivePin = { fg = nordfox.magenta.dim, bg = nordfox.bg0 },
    BufferInactiveSeparator = { fg = nordfox.bg0, bg = nordfox.bg0 },
    
    -- 表示されているが非アクティブなタブ
    BufferVisible = { fg = nordfox.fg2, bg = nordfox.sel0 },
    BufferVisibleERROR = { fg = nordfox.red.base, bg = nordfox.sel0 },
    BufferVisibleHINT = { fg = nordfox.cyan.base, bg = nordfox.sel0 },
    BufferVisibleINFO = { fg = nordfox.blue.base, bg = nordfox.sel0 },
    BufferVisibleWARN = { fg = nordfox.yellow.base, bg = nordfox.sel0 },
    BufferVisibleIndex = { fg = nordfox.fg2, bg = nordfox.sel0 },
    BufferVisibleMod = { fg = nordfox.orange.base, bg = nordfox.sel0 },
    BufferVisibleSign = { fg = nordfox.fg2, bg = nordfox.sel0 },
    BufferVisibleTarget = { fg = nordfox.red.base, bg = nordfox.sel0 },
    BufferVisibleIcon = { fg = nordfox.fg2, bg = nordfox.sel0 },
    BufferVisibleButton = { fg = nordfox.red.base, bg = nordfox.sel0 },
    BufferVisiblePin = { fg = nordfox.magenta.base, bg = nordfox.sel0 },
    BufferVisibleSeparator = { fg = nordfox.bg0, bg = nordfox.sel0 },
    
    -- タブライン本体
    BufferTabpages = { fg = nordfox.fg3, bg = nordfox.bg0, bold = true },
    BufferTabpageFill = { fg = nordfox.fg3, bg = nordfox.bg0 },
    BufferOffset = { fg = nordfox.fg3, bg = nordfox.bg0 },
  }
  
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
        -- アクティブタブのアイコン
        vim.api.nvim_set_hl(0, 'BufferCurrent' .. name, { 
          fg = icon_data.color or nordfox.fg1, 
          bg = nordfox.bg1 
        })
        -- 非アクティブタブのアイコン
        vim.api.nvim_set_hl(0, 'BufferInactive' .. name, { 
          fg = icon_data.color or nordfox.fg3, 
          bg = nordfox.bg0 
        })
        -- 表示中タブのアイコン
        vim.api.nvim_set_hl(0, 'BufferVisible' .. name, { 
          fg = icon_data.color or nordfox.fg2, 
          bg = nordfox.sel0 
        })
      end
    end
  end
end

return M