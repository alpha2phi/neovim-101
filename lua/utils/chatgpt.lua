local M = {}

local curl = require("plenary.curl")

PROMPTS_FILE = "https://raw.githubusercontent.com/f/awesome-chatgpt-prompts/main/prompts.csv"

function M.download_prompts()
	local res = curl.get(PROMPTS_FILE)
	local result = res.body
	local prompts = nil
	for line in result:gmatch("[^\r\n]+") do
		if prompts then
			print(line)
			return
		-- prompts.insert({})
		else
			prompts = {}
		end
	end
end

M.download_prompts()

return M
