if vim.fn.has("wsl") == 1 and not vim.g.vscode then
	-- WSL terminal Neovim only (VSCode Neovim handles clipboard itself)
	vim.g.clipboard = {
		name = "WslClipboard",
		copy = {
			["+"] = { "win32yank.exe", "-i", "--crlf" },
			["*"] = { "win32yank.exe", "-i", "--crlf" },
		},
		paste = {
			["+"] = { "win32yank.exe", "-o", "--lf" },
			["*"] = { "win32yank.exe", "-o", "--lf" },
		},
		cache_enabled = 1,
	}
elseif vim.fn.has("win32") == 1 then
	-- Native Windows Neovim (not via WSL)
	vim.g.clipboard = {
		name = "Win32Clipboard",
		copy = {
			["+"] = { "C:/bin/win32yank.exe", "-i", "--crlf" },
			["*"] = { "C:/bin/win32yank.exe", "-i", "--crlf" },
		},
		paste = {
			["+"] = { "C:/bin/win32yank.exe", "-o", "--lf" },
			["*"] = { "C:/bin/win32yank.exe", "-o", "--lf" },
		},
		cache_enabled = 1,
	}
end
