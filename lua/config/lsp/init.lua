require("config.lsp.python")
require("config.lsp.lua")

local api = vim.api
local keymap = vim.keymap.set

local function keymappings(_, bufnr)
	local opts = { noremap = true, silent = true }

	keymap("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
	keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
	keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
	keymap("n", "[e", "<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})<CR>", opts)
	keymap("n", "]e", "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})<CR>", opts)

	keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
	keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	keymap("n", "gh", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	keymap("n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	keymap("n", "gb", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)

	api.nvim_set_keymap("i", "<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { noremap = true, expr = true })
	api.nvim_set_keymap("i", "<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { noremap = true, expr = true })
end

local function highlighting(client, bufnr)
	if client.server_capabilities.documentHighlightProvider then
		local lsp_highlight_grp = api.nvim_create_augroup("LspDocumentHighlight", { clear = true })
		api.nvim_create_autocmd("CursorHold", {
			callback = function()
				vim.schedule(vim.lsp.buf.document_highlight)
			end,
			group = lsp_highlight_grp,
			buffer = bufnr,
		})
		api.nvim_create_autocmd("CursorMoved", {
			callback = function()
				vim.schedule(vim.lsp.buf.clear_references)
			end,
			group = lsp_highlight_grp,
			buffer = bufnr,
		})
	end
end

local function lsp_handlers()
	local diagnostics = {
		Error = "",
		Hint = "",
		Information = "",
		Question = "",
		Warning = "",
	}
	local signs = {
		{ name = "DiagnosticSignError", text = diagnostics.Error },
		{ name = "DiagnosticSignWarn", text = diagnostics.Warning },
		{ name = "DiagnosticSignHint", text = diagnostics.Hint },
		{ name = "DiagnosticSignInfo", text = diagnostics.Info },
	}
	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
	end

	-- LSP handlers configuration
	local config = {
		float = {
			focusable = true,
			style = "minimal",
			border = "rounded",
		},

		diagnostic = {
			virtual_text = { severity = vim.diagnostic.severity.ERROR },
			signs = {
				active = signs,
			},
			underline = true,
			update_in_insert = false,
			severity_sort = true,
			float = {
				focusable = true,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		},
	}

	vim.diagnostic.config(config.diagnostic)
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, config.float)
	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, config.float)
end

local function formatting(client, bufnr)
	if client.server_capabilities.documentFormattingProvider then
		local function format()
			local view = vim.fn.winsaveview()
			vim.lsp.buf.format({
				async = true,
				filter = function(attached_client)
					return attached_client.name ~= ""
				end,
			})
			vim.fn.winrestview(view)
		end

		local lsp_format_grp = api.nvim_create_augroup("LspFormat", { clear = true })
		api.nvim_create_autocmd("BufWritePre", {
			callback = function()
				vim.schedule(format)
			end,
			group = lsp_format_grp,
			buffer = bufnr,
		})
	end
end

local function on_attach(client, bufnr)
	if client.server_capabilities.completionProvider then
		vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
		vim.bo[bufnr].completefunc = "v:lua.vim.lsp.omnifunc"
	end

	if client.server_capabilities.definitionProvider then
		vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
	end

	if client.server_capabilities.documentFormattingProvider then
		vim.bo[bufnr].formatexpr = "v:lua.vim.lsp.formatexpr()"
	end

	keymappings(client, bufnr)
	highlighting(client, bufnr)
	formatting(client, bufnr)
end

lsp_handlers()

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local bufnr = args.buf
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		on_attach(client, bufnr)
	end,
})
