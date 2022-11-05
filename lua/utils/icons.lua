local icons = require("nvim-web-devicons").get_icons()

vim.pretty_print(vim.tbl_count(icons))
for _, v in pairs(icons) do
  print(v.name, v.icon)
end
