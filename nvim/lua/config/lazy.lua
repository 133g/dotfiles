-- lazy.nvimのセットアップ
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- nvimプラグインの読込
require("lazy").setup({
  spec = {
    { import = "plugins.nightfox" },
    { import = "plugins.treesitter" },
    { import = "plugins.lualine" },
    { import = "plugins.barbar" },
    { import = "plugins.oil" },
    { import = "plugins.hlchunk" },
  }
})


