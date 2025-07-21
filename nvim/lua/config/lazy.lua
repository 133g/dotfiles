-- setup for lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- load nvim plugins
require("lazy").setup({
  spec = {
    { import = "plugins.catppuccin" },
    { import = "plugins.lualine" },
    --{ import = "plugins.barbar" },
    { import = "plugins.oil" },
    --{ import = "plugins.hlchunk" },
    { import = "plugins.lsp" },
    { import = "plugins.copilot" },
  },
})

-- add keymap when attached LSP Server only
--vim.api.nvim_create_autocmd("LspAttach", {
--  callback = function(ctx)
--    local set = vim.keymap.set
--    set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { buffer = true })
--    set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { buffer = true })
--    set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { buffer = true })
--    set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", { buffer = true })
--    set("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { buffer = true })
--    set("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", { buffer = true })
--    set("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", { buffer = true })
--    set("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", { buffer = true })
--    set("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", { buffer = true })
--    set("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", { buffer = true })
--    set("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", { buffer = true })
--    set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", { buffer = true })
--    set("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", { buffer = true })
--    set("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", { buffer = true })
--    set("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", { buffer = true })
--    set("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", { buffer = true })
--    set("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", { buffer = true })
--  end,
--})
