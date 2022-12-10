local if_nil = vim.F.if_nil
local leader = "SPC"

local function button(sc, txt, keybind, keybind_opts)
  local sc_ = sc:gsub("%s", ""):gsub(leader, "<leader>")

  local opts = {
    position = "center",
    shortcut = sc,
    cursor = 5,
    width = 50,
    align_shortcut = "right",
    hl_shortcut = "Keyword",
  }
  if keybind then
    keybind_opts = if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
    opts.keymap = { "n", sc_, keybind, keybind_opts }
  end

  local function on_press()
    local key = vim.api.nvim_replace_termcodes(keybind or sc_ .. "<Ignore>", true, false, true)
    vim.api.nvim_feedkeys(key, "t", false)
  end

  return {
    type = "button",
    val = txt,
    on_press = on_press,
    opts = opts,
  }
end

local buttons = {
  type = "group",
  val = {
    button("e", "  New file", "<cmd>ene <CR>"),
    button("SPC f f", "  Find file"),
    button("SPC f h", "  Recently opened files"),
    button("SPC f r", "  Frecency/MRU"),
    button("SPC f g", "  Find word"),
    button("SPC f m", "  Jump to bookmarks"),
    button("SPC s l", "  Open last session"),
  },
  opts = {
    spacing = 1,
  },
}


local term_height = 15
local config = {
  layout = {
    { type = "padding", val = term_height + 5 },
    {
      type = "terminal",
      command = "cmatrix",
      width = 50,
      height = term_height,
      opts = {
        redraw = true,
        window_config = {},
      },
    },
    --{ type = "padding", val = 5 },
    buttons,
  },
  opts = {
    noautocmd = false,
  },
}

local alpha = require("alpha")
require("alpha.term")

alpha.setup(config)
