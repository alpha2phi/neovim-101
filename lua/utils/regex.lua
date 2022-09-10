-- A sample license plate number is "1MGU103".  
-- It has one digit, three uppercase letters and three digits.
local regex_1 = vim.regex([[\d\u\u\u\d\d\d]])
local regex_2 = vim.regex([[\d\u\{3}\d\{3}]])
local regex_3 = vim.regex([[[0-9][A-Z]\{3}[0-9]\{3}]])

local match_str = "This is a plate number 1ABC999"

vim.pretty_print(regex_1:match_str(match_str))
vim.pretty_print(regex_2:match_str(match_str))
vim.pretty_print(regex_3:match_str(match_str))


