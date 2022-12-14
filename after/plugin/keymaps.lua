local g = vim.g
local api = vim.api
local keymap = vim.keymap.set

-- Space as leader key
keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
g.mapleader = " "
g.maplocalleader = ","

-- Word wrap
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

-- jk to ESC
keymap("i", "jk", "<ESC>", { noremap = true, silent = true })

-- Toggle terminal
keymap("n", "<Leader>t", '<CMD>lua require("FTerm").toggle()<CR>')
keymap("t", "<Leader>t", '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')

-- CSI u mappings test
--keymap("n", "<Tab>", '<CMD>lua print([[ Tab is pressed ]])<CR>')
--keymap("n", "<C-i>", '<CMD>lua print([[ Ctr-i is pressed ]])<CR>')
--keymap("n", "<C-Enter>", '<CMD>lua print([[ Ctr-Enter is pressed ]])<CR>')
--keymap("n", "<C-S-p>", '<CMD>lua print([[ Ctr-Shift-P is pressed ]])<CR>')
--
vim.cmd [[
nnoremap <silent><expr> <LocalLeader>r  :MagmaEvaluateOperator<CR>
nnoremap <silent>       <LocalLeader>rr :MagmaEvaluateLine<CR>
xnoremap <silent>       <LocalLeader>r  :<C-u>MagmaEvaluateVisual<CR>
nnoremap <silent>       <LocalLeader>rc :MagmaReevaluateCell<CR>
nnoremap <silent>       <LocalLeader>rd :MagmaDelete<CR>
nnoremap <silent>       <LocalLeader>ro :MagmaShowOutput<CR>

let g:magma_automatically_open_output = v:false
let g:magma_image_provider = "ueberzug"

]]
