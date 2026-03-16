if vim.fn.has("wsl") == 1 and not vim.g.vscode then
	-- WSL terminal Neovim only (VSCode Neovim handles clipboard itself).
	-- Use bash -c to invoke .exe: libuv's execvp falls back to /bin/sh on ENOEXEC
	-- when binfmt_misc WSL interop does not trigger, causing "Syntax error".
	-- Routing through bash ensures WSL's .exe interop handler is used instead.
	vim.g.clipboard = {
		name = "WslClipboard",
		copy = {
			["+"] = { "bash", "-c", "/mnt/c/bin/win32yank.exe -i --crlf" },
			["*"] = { "bash", "-c", "/mnt/c/bin/win32yank.exe -i --crlf" },
		},
		paste = {
			["+"] = { "bash", "-c", "/mnt/c/bin/win32yank.exe -o --lf" },
			["*"] = { "bash", "-c", "/mnt/c/bin/win32yank.exe -o --lf" },
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
