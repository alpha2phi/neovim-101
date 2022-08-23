--https://manytools.org/hacker-tools/ascii-banner

local function header()
	return [[
     ███╗   ██╗██╗   ██╗███╗   ███╗███╗   ███╗
     ████╗  ██║██║   ██║████╗ ████║████╗ ████║
     ██╔██╗ ██║██║   ██║██╔████╔██║██╔████╔██║
     ██║╚██╗██║╚██╗ ██╔╝██║╚██╔╝██║██║╚██╔╝██║
     ██║ ╚████║ ╚████╔╝ ██║ ╚═╝ ██║██║ ╚═╝ ██║
     ╚═╝  ╚═══╝  ╚═══╝  ╚═╝     ╚═╝╚═╝     ╚═╝ 
  ]]
end

require("mini.sessions").setup({})

local starter = require("mini.starter")
starter.setup({
	evaluate_single = true,
	header = header,
	items = {
		starter.sections.builtin_actions(),
		starter.sections.recent_files(10, false),
		starter.sections.recent_files(10, true),
		starter.sections.sessions(5, true),
	},
	content_hooks = {
		starter.gen_hook.adding_bullet(),
		starter.gen_hook.indexing("all", { "Builtin actions" }),
		starter.gen_hook.padding(3, 2),
	},
})
