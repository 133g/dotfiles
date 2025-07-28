return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
	lazy = false,
	config = function()
		require("oil").setup({
			view_options = {
				show_hidden = true,
			},
		})

		vim.keymap.set("n", "-", function()
			require("oil").open()
		end, { desc = "Open parent directory in current window" })
		vim.keymap.set("n", "_", function()
			require("oil").open(".")
		end, { desc = "Open current directory in current window" })
		vim.keymap.set(
			"n",
			"<leader>-",
			require("oil").toggle_float,
			{ desc = "Open parent directory in floating window" }
		)
		vim.keymap.set("n", "<leader>_", function()
			require("oil").toggle_float(".")
		end, { desc = "Open current directory in floating window" })
	end,
}
