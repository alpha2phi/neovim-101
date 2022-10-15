local cmd = vim.cmd
local fn = vim.fn
local api = vim.api

local packer_bootstrap = false -- Indicate first time installation

-- packer.nvim configuration
local conf = {
	profile = {
		enable = true,
		threshold = 0, -- the amount in ms that a plugins load time must be over for it to be included in the profile
	},

	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
}

local function packer_init()
	-- Check if packer.nvim is installed
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		packer_bootstrap = fn.system({
			"git",
			"clone",
			"--depth",
			"1",
			"https://github.com/wbthomason/packer.nvim",
			install_path,
		})
		cmd([[packadd packer.nvim]])
	end

	-- Run PackerCompile if there are changes in this file
	local packerGrp = api.nvim_create_augroup("packer_user_config", { clear = true })
	api.nvim_create_autocmd(
		{ "BufWritePost" },
		{ pattern = "init.lua", command = "source <afile> | PackerCompile", group = packerGrp }
	)
end

-- Plugins
local function plugins(use)
	use({ "wbthomason/packer.nvim" })
	use({ "kyazdani42/nvim-web-devicons" })
	use({ "nvim-lua/plenary.nvim" })
	use({ "stevearc/dressing.nvim" })
	use({ "MunifTanjim/nui.nvim" })

	use({
		"TimUntersberger/neogit",
		cmd = { "Neogit" },
		config = function()
			require("neogit").setup({})
		end,
	})

	-- Colorscheme
	use({
		"folke/tokyonight.nvim",
		config = function()
			vim.cmd.colorscheme("tokyonight")
		end,
	})

	use({
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("config.treesitter")
		end,
		requires = {
			"nvim-treesitter/playground",
			"nvim-treesitter/nvim-treesitter-textobjects",
			{
				"m-demare/hlargs.nvim",
				config = function()
					require("hlargs").setup()
				end,
			},
		},
	})

	use({
		"nvim-telescope/telescope.nvim",
		requires = { "nvim-telescope/telescope-media-files.nvim" },
		config = function()
			require("config.telescope")
		end,
	})

	-- View image in buffer
	use({
		"edluffy/hologram.nvim",
		config = function()
			require("hologram").setup({
				auto_display = true,
			})
		end,
		disable = true,
	})

	-- Ranger terminal file manager
	use({ "kevinhwang91/rnvimr" })

	-- ASCII image viewer
	use({
		"samodostal/image.nvim",
		config = function()
			require("image").setup({
				render = {
					min_padding = 5,
					show_label = true,
					use_dither = true,
				},
				events = {
					update_on_nvim_resize = true,
				},
			})
		end,
	})

	use({
		"adelarsq/image_preview.nvim",
		config = function()
			require("image_preview").setup({})
		end,
	})

	-- FZF
	use({
		"ibhagwan/fzf-lua",
		config = function()
			require("config.fzf-lua")
		end,
	})

	-- Regular expression
	use({
		"bennypowers/nvim-regexplainer",
		config = function()
			require("regexplainer").setup({
				auto = true,
				filetypes = {
					"html",
					"js",
					"cjs",
					"mjs",
					"ts",
					"jsx",
					"tsx",
					"cjsx",
					"mjsx",
					"lua",
				},
				debug = true,
			})
		end,
		requires = {
			"nvim-treesitter/nvim-treesitter",
			"MunifTanjim/nui.nvim",
		},
		disable = true,
	})
	use({
		"Djancyp/regex.nvim",
		config = function()
			require("regex-nvim").Setup()
		end,
		disable = true,
	})

	-- Terminal
	use({ "numToStr/FTerm.nvim" })

	-- Icon picker
	use({
		"ziontee113/icon-picker.nvim",
		config = function()
			require("icon-picker").setup({
				disable_legacy_commands = true,
			})
		end,
		disable = true,
	})

	-- Colors
	use({
		"max397574/colortils.nvim",
		cmd = "Colortils",
		config = function()
			require("colortils").setup()
		end,
		disable = true,
	})
	use({
		"lifepillar/vim-colortemplate",
		disable = true,
	})
	use({
		"NvChad/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
		disable = true,
	})
	use({
		"ziontee113/color-picker.nvim",
		config = function()
			require("color-picker")
		end,
		disable = true,
	})
	use({
		"uga-rosa/ccc.nvim",
		config = function()
			require("ccc").setup({})
		end,
		disable = false,
	})
	use({
		"rrethy/vim-hexokinase",
		run = "make hexokinase",
		config = function()
			vim.g.Hexokinase_highlighters = { "virtual", "sign_column", "background" }
		end,
		disable = true,
	})
	use({ "KabbAmine/vCoolor.vim", disable = true })

	-- File explorer
	use({ "tamago324/lir.nvim", disable = true })

	-- Buffer line

	-- Status line
	use({ "rebelot/heirline.nvim" })

	-- Search
	use({
		"lalitmee/browse.nvim",
		requires = { "nvim-telescope/telescope.nvim" },
		config = function()
			require("config.browse")
		end,
	})

	-- Windows and buffers
	use({
		"karb94/neoscroll.nvim",
		config = function()
			require("neoscroll").setup()
		end,
	})
	use({
		"anuvyklack/windows.nvim",
		requires = {
			"anuvyklack/middleclass",
			"anuvyklack/animation.nvim",
		},
		config = function()
			vim.o.winwidth = 15
			vim.o.winminwidth = 10
			vim.o.equalalways = false
			require("windows").setup()
		end,
		disable = true,
	})
	use({
		"beauwilliams/focus.nvim",
		config = function()
			require("focus").setup({ hybridnumber = true })
		end,
		disable = true,
	})
	use({ "sindrets/winshift.nvim", disable = true })
	use({
		"luukvbaal/stabilize.nvim",
		config = function()
			require("stabilize").setup()
		end,
		disable = false,
	})
	use({
		"ghillb/cybu.nvim",
		branch = "main", -- timely updates
		-- branch = "v1.x", -- won't receive breaking changes
		requires = { "kyazdani42/nvim-web-devicons", "nvim-lua/plenary.nvim" }, -- optional for icon support
		config = function()
			local ok, cybu = pcall(require, "cybu")
			if not ok then
				return
			end
			cybu.setup()
			vim.keymap.set("n", "K", "<Plug>(CybuPrev)")
			vim.keymap.set("n", "J", "<Plug>(CybuNext)")
			vim.keymap.set({ "n", "v" }, "<c-s-tab>", "<plug>(CybuLastusedPrev)")
			vim.keymap.set({ "n", "v" }, "<c-tab>", "<plug>(CybuLastusedNext)")
		end,
		disable = true,
	})
	use({
		"folke/noice.nvim",
		config = function()
			require("noice").setup()
		end,
		requires = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
	})
	use({
		"matbme/JABS.nvim",
		config = function()
			require("jabs").setup({})
		end,
	})

	-- Code outline
	use({ "preservim/tagbar" })
	use({ "liuchengxu/vista.vim" })

	-- Code Runner
	use({ "metakirby5/codi.vim" })
	use({
		"0x100101/lab.nvim",
		config = function()
			require("lab").setup({
				quick_data = {
					enabled = true,
				},
			})
		end,
		disable = true,
	})

	use({
		"phaazon/notisys.nvim",
		branch = "v0.1",
		config = function()
			require("notisys").setup()
		end,
		disable = true,
	})
	use({
		"smjonas/live-command.nvim",
		-- live-command supports semantic versioning via tags
		-- tag = "1.*",
		config = function()
			require("live-command").setup({
				commands = {
					Norm = { cmd = "norm" },
				},
			})
		end,
	})

	-- Bootstrap Neovim
	if packer_bootstrap then
		print("Neovim restart is required after installation!")
		require("packer").sync()
	end
end

-- packer.nvim
packer_init()
local packer = require("packer")
packer.init(conf)
packer.startup(plugins)
