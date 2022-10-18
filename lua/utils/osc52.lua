local output = vim.api.nvim_cmd({
	cmd = "ls",
}, { output = true })

print(output)
