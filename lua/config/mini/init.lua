-- default settings
require("mini.cursorword").setup({})
require("mini.comment").setup({})
require("mini.jump").setup({})
require("mini.surround").setup({})
require("mini.tabline").setup({})
require("mini.completion").setup({})
require("mini.indentscope").setup({})
require("mini.pairs").setup({})
require("mini.jump2d").setup({
	mappings = {
		start_jumping = "S",
	},
})
require("mini.bufremove").setup({})
require("mini.doc").setup({})
require("mini.ai").setup({})

-- custom settings
require("config.mini.base16")
require("config.mini.starter")
require("config.mini.statusline")
