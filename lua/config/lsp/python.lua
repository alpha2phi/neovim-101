local bin_name = "pyright-langserver"
local cmd = { bin_name, "--stdio" }

if vim.fn.has("win32") == 1 then
	cmd = { "cmd.exe", "/C", bin_name, "--stdio" }
end

local root_files = {
	"pyproject.toml",
	"setup.py",
	"setup.cfg",
	"requirements.txt",
	"Pipfile",
	"pyrightconfig.json",
}

vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function()
		vim.lsp.start({
			name = "pyright",
			cmd = cmd,
			root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
			settings = {
				python = {
					analysis = {
						autoSearchPaths = true,
						useLibraryCodeForTypes = true,
						diagnosticMode = "workspace",
					},
				},
			},
		})
	end,
})
