local icons = require("nvim-web-devicons").get_icons()

print("No of icons: ", vim.tbl_count(icons))
for _, v in pairs(icons) do
	print(v.name, v.icon)
end
