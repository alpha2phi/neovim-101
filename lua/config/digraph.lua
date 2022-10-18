local M = {}

local keymap = vim.keymap.set

keymap("i", "<C-k><C-k>", "<cmd>lua require'better-digraphs'.digraphs('i')<cr>", {})
keymap("n", "r<C-k><C-k>", "<cmd>lua require'better-digraphs'.digraphs('r')<cr>", {})
