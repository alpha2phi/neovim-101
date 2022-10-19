local root_files = {
	".luarc.json",
	".luacheckrc",
	".stylua.toml",
	"stylua.toml",
	"selene.toml",
	".git",
}

local bin_name = "lua-language-server"
local cmd = { bin_name }

if vim.fn.has("win32") == 1 then
	cmd = { "cmd.exe", "/C", bin_name }
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "lua",
	callback = function()
		vim.lsp.start({
			name = "sumneko",
			cmd = cmd,
			root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
					},
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
					},
					telemetry = {
						enable = false,
					},
				},
			},
		})
	end,
})
