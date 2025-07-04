require("config.lazy")
require("config.options")
require("config.keymaps")
require("config.ime")
require("config.wsl")

-- barbar.nvimの色設定をオートコマンドで適用
vim.api.nvim_create_autocmd({"ColorScheme", "VimEnter"}, {
  pattern = "*",
  callback = function()
    vim.schedule(function()
      local ok, barbar_colors = pcall(require, 'config.barbar-colors')
      if ok then
        barbar_colors.setup()
      end
    end)
  end,
})