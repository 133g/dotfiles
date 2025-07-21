return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls", -- Lua言語サーバー
					"ts_ls", -- TypeScript/JavaScript言語サーバー
					"biome",
				},
				automatic_enable = true,
			})
		end,
	},
	{
		"jay-babu/mason-null-ls.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"nvimtools/none-ls.nvim",
		},
		config = function()
			require("mason-null-ls").setup({
				ensure_installed = {
					"stylua", -- Luaフォーマッター
					"biome", -- JavaScript/TypeScriptフォーマッター・リンター
				},
			})
		end,
	},
	{
		-- lspconfig.lua - LSPサーバー設定用
		"neovim/nvim-lspconfig",
		config = function()
			-- vim.lsp.config()を使用（Neovim 0.11+の新しいLSP設定API）（必須）
			vim.lsp.config("*", {
				-- 全LSPサーバー共通設定（'*'は全サーバーを意味）（必須）
				on_attach = function(client, bufnr)
					-- LSPサーバーがバッファにアタッチされた時の処理（必須）

					-- キーマップ設定（このバッファでのみ有効）（オプション）
					local opts = { buffer = bufnr, silent = true } -- オプション引数（必須）

					-- gd: 定義へジャンプ（オプション）
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					-- K: ホバー情報表示（オプション）
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					-- <leader>ca: コードアクション表示（オプション）
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
					-- <leader>rn: シンボルリネーム（オプション）
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				end,
			})

			-- 個別サーバー設定：Lua言語サーバー（オプション）
			vim.lsp.config("lua_ls", {
				settings = { -- サーバー固有設定（オプション）
					Lua = {
						-- Luaランタイム設定（オプション）
						runtime = { version = "LuaJIT" }, -- NeovimはLuaJITを使用
						-- 診断設定（オプション）
						diagnostics = { globals = { "vim" } }, -- 'vim'をグローバル変数として認識
						-- ワークスペース設定（オプション）
						workspace = {
							-- Neovimのランタイムファイルをライブラリとして追加（オプション）
							library = vim.api.nvim_get_runtime_file("", true),
							-- サードパーティライブラリの確認を無効化（オプション）
							checkThirdParty = false,
						},
					},
				},
			})

			-- TypeScript/JavaScript言語サーバー設定（オプション）
			vim.lsp.config("ts_ls", {
				-- 必要に応じてカスタム設定を追加（オプション）
			})

			vim.lsp.config("biome", {})
		end,
	},
	{
		-- null-ls.lua - Linter/Formatter設定
		"nvimtools/none-ls.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local null_ls = require("null-ls")

			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.stylua,
				},
				-- None-LSサーバーがバッファにアタッチされた時の処理（オプション）
				on_attach = function(client, bufnr)
					-- フォーマット機能をサポートしているかチェック（必須判定）
					if client.server_capabilities.documentFormattingProvider then
						-- ファイル保存時に自動フォーマットを設定（オプション機能）
						vim.api.nvim_create_autocmd("BufWritePre", {
							buffer = bufnr, -- 現在のバッファのみに適用（必須引数）
							callback = function()
								-- 同期的にフォーマット実行（保存前に完了）（必須設定）
								vim.lsp.buf.format({ async = false })
							end,
						})
					end
				end,
			})
		end,
	},
}
