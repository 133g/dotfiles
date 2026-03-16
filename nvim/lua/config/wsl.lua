if vim.fn.has("wsl") == 1 and not vim.g.vscode then
	vim.g.clipboard = {
		name = "WslClipboard",
		copy = {
			["+"] = "win32yank.exe -i",
			["*"] = "win32yank.exe -i",
		},
		paste = {
			["+"] = "win32yank.exe -o",
			["*"] = "win32yank.exe -o",
		},
		cache_enabled = 1,
	}
elseif vim.fn.has("win32") == 1 then
	vim.g.clipboard = {
		name = "Win32Clipboard",
		copy = {
			["+"] = "C:/bin/win32yank.exe -i",
			["*"] = "C:/bin/win32yank.exe -i",
		},
		paste = {
			["+"] = "C:/bin/win32yank.exe -o",
			["*"] = "C:/bin/win32yank.exe -o",
		},
		cache_enabled = 1,
	}
end
