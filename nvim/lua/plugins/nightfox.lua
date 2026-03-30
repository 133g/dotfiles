return {
  "EdenEast/nightfox.nvim",
  config = function()
    -- 透明背景設定（テーマ共通）
    vim.cmd([[
      hi Normal       guibg=NONE ctermbg=NONE
      hi NormalNC     guibg=NONE ctermbg=NONE
      hi NormalFloat  guibg=NONE ctermbg=NONE
      hi Pmenu        guibg=NONE ctermbg=NONE
      hi EndOfBuffer  guibg=NONE ctermbg=NONE
    ]])
  end,
}
