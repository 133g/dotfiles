return {
  "EdenEast/nightfox.nvim",
  config = function()
    -- 透明設定は colorscheme より前に
    vim.g.nightfox_transparent = true

    -- カラースキームの設定
    vim.cmd("colorscheme nordfox")
    vim.cmd([[
      hi Normal       guibg=NONE ctermbg=NONE
      hi NormalNC     guibg=NONE ctermbg=NONE
      hi NormalFloat  guibg=NONE ctermbg=NONE
      hi Pmenu        guibg=NONE ctermbg=NONE
      hi EndOfBuffer  guibg=NONE ctermbg=NONE
    ]])
  end,
}
