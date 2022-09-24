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
    disable = true
  })

  -- Colors
  use({
    "max397574/colortils.nvim",
    cmd = "Colortils",
    config = function()
      require("colortils").setup()
    end,
    disable = true
  })
  use({ 
    "lifepillar/vim-colortemplate",
    disable = true
  })
  use({
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
    disable = true
  })
  use({
    "ziontee113/color-picker.nvim",
    config = function()
      require("color-picker")
    end,
    disable = true
  })
  use({
    "uga-rosa/ccc.nvim",
    config = function()
      require("ccc").setup({})
    end,
    disable = false
  })
  use({
    "rrethy/vim-hexokinase",
    run = "make hexokinase",
    config = function()
      vim.g.Hexokinase_highlighters = { "virtual", "sign_column", "background" }
    end,
    disable = true
  })
  use ({"KabbAmine/vCoolor.vim", disable = true})


  -- File explorer
  use {"tamago324/lir.nvim", disable = true}


  -- Buffer line
  

  -- Status line
  use {"rebelot/heirline.nvim"}


  -- Search
  use({
    "lalitmee/browse.nvim",
    requires = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("config.browse")
    end
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
