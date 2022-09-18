local query_1 = [[
;; query
  (function_definition 
    name: (identifier) @func_name (#offset! @func_name)
  ) 
]]

local query_2 = [[
  (function_definition 
    name: (identifier) @func_name (#offset! @func_name)
  ) 
]]


local tql_3 = [[
  (function_definition 
    name: (identifier) @func_name (#offset! @func_name)
  ) 
]]

local function function_1(a, b)
	print("Function 1")
end

local function function_2(x, y)
	print("Function 2")
end
