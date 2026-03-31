vim.lsp.enable({
  -- nvim-lspconfig で設定したプリセットが読まれる
  -- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/
  "lua_ls",
  "ts_ls",
  "biome",
})

-- 言語サーバーがアタッチされた時に呼ばれる
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("my.lsp", {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    local buf = args.buf

    -- デフォルトで設定されている言語サーバー用キーバインドに設定を追加する
    -- See https://neovim.io/doc/user/lsp.html#lsp-defaults

    if client:supports_method("textDocument/definition") then
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = buf, desc = "Go to definition" })
    end

    if client:supports_method("textDocument/hover") then
      vim.keymap.set("n", "<leader>k", function()
        vim.lsp.buf.hover({ border = "single" })
      end, { buffer = buf, desc = "Show hover documentation" })
    end

    if client:supports_method("textDocument/codeAction") then
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = buf, desc = "Code action" })
    end

    if client:supports_method("textDocument/rename") then
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = buf, desc = "Rename symbol" })
    end

    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { buffer = buf, desc = "Show diagnostics" })

    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end

    -- Auto-format on save.
    -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
    if
        not client:supports_method("textDocument/willSaveWaitUntil")
        and client:supports_method("textDocument/formatting")
    then
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("my.lsp", { clear = false }),
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
        end,
      })
    end
  end,
})

-- stylua による Lua ファイルの自動フォーマット（LSP外のフォーマッター）
if vim.fn.executable("stylua") == 1 then
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("my.stylua", {}),
    pattern = "*.lua",
    callback = function(args)
      local filepath = vim.api.nvim_buf_get_name(args.buf)
      vim.fn.system({ "stylua", filepath })
      vim.cmd.edit({ bang = true })
    end,
  })
end
