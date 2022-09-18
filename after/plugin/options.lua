local opt = vim.opt

opt.breakindent = true
opt.clipboard = "unnamedplus"
opt.hidden = true
opt.hlsearch = false
opt.ignorecase = true
opt.laststatus = 3
opt.mouse = "a"
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.smartcase = true
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.undofile = true
opt.updatetime = 250
opt.laststatus = 3
opt.cmdheight = 0
opt.expandtab = true

opt.path:remove("/usr/include")
opt.path:append("**")
opt.wildignorecase = true
opt.wildignore:append("**/node_modules/*")
opt.wildignore:append("**/.git/*")
