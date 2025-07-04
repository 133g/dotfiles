-- 日本語IMEの設定
if vim.fn.executable('zenhan') == 1 then
  vim.api.nvim_create_autocmd('InsertLeave', {
    callback = function()
      vim.fn.system('zenhan 0')
    end
  })
  vim.api.nvim_create_autocmd('CmdlineLeave', {
    callback = function()
      vim.fn.system('zenhan 0')
    end
  })
end

if vim.fn.executable('im-select') == 1 then
  vim.api.nvim_create_autocmd('InsertLeave', {
    callback = function()
      vim.fn.system('im-select com.apple.keylayout.UnicodeHexInput')
    end
  })
  vim.api.nvim_create_autocmd('CmdlineLeave', {
    callback = function()
      vim.fn.system('im-select 0')
    end
  })
end