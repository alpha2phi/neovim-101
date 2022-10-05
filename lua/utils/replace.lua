local function show_replace_preview(use_preview_win, preview_ns, preview_buf, matches)
	-- Find the width taken by the largest line number, used for padding the line numbers
	local highest_lnum = math.max(matches[#matches][1], 1)
	local highest_lnum_width = math.floor(math.log10(highest_lnum))
	local preview_buf_line = 0
	local multibuffer = #matches > 1
	for _, match in ipairs(matches) do
		local buf = match[1]
		local buf_matches = match[2]
		if multibuffer and #buf_matches > 0 and use_preview_win then
			local bufname = vim.api.nvim_buf_get_name(buf)
			if bufname == "" then
				bufname = string.format("Buffer #%d", buf)
			end
			vim.api.nvim_buf_set_lines(preview_buf, preview_buf_line, preview_buf_line, 0, { bufname .. ":" })
			preview_buf_line = preview_buf_line + 1
		end
		for _, buf_match in ipairs(buf_matches) do
			local lnum = buf_match[1]
			local line_matches = buf_match[2]
			local prefix
			if use_preview_win then
				prefix =
					string.format("|%s%d| ", string.rep(" ", highest_lnum_width - math.floor(math.log10(lnum))), lnum)
				vim.api.nvim_buf_set_lines(
					preview_buf,
					preview_buf_line,
					preview_buf_line,
					0,
					{ prefix .. vim.api.nvim_buf_get_lines(buf, lnum - 1, lnum, false)[1] }
				)
			end
			for _, line_match in ipairs(line_matches) do
				vim.api.nvim_buf_add_highlight(buf, preview_ns, "Substitute", lnum - 1, line_match[1], line_match[2])
				if use_preview_win then
					vim.api.nvim_buf_add_highlight(
						preview_buf,
						preview_ns,
						"Substitute",
						preview_buf_line,
						#prefix + line_match[1],
						#prefix + line_match[2]
					)
				end
			end
			preview_buf_line = preview_buf_line + 1
		end
	end
	if use_preview_win then
		return 2
	else
		return 1
	end
end

local function do_replace(opts, preview, preview_ns, preview_buf)
	local pat1 = opts.fargs[1]
	if not pat1 then
		return
	end
	local pat2 = opts.fargs[2] or ""
	local line1 = opts.line1
	local line2 = opts.line2
	local matches = {}
	-- Get list of valid and listed buffers
	local buffers = vim.tbl_filter(function(buf)
		if not (vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted and buf ~= preview_buf) then
			return false
		end
		-- Check if there's at least one window using the buffer
		for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
			if vim.api.nvim_win_get_buf(win) == buf then
				return true
			end
		end
		return false
	end, vim.api.nvim_list_bufs())
	for _, buf in ipairs(buffers) do
		local lines = vim.api.nvim_buf_get_lines(buf, line1 - 1, line2, false)
		local buf_matches = {}
		for i, line in ipairs(lines) do
			local startidx, endidx = 0, 0
			local line_matches = {}
			local num = 1
			while startidx ~= -1 do
				local match = vim.fn.matchstrpos(line, pat1, 0, num)
				startidx, endidx = match[2], match[3]
				if startidx ~= -1 then
					line_matches[#line_matches + 1] = { startidx, endidx }
				end
				num = num + 1
			end
			if #line_matches > 0 then
				buf_matches[#buf_matches + 1] = { line1 + i - 1, line_matches }
			end
		end
		local new_lines = {}
		for _, buf_match in ipairs(buf_matches) do
			local lnum = buf_match[1]
			local line_matches = buf_match[2]
			local line = lines[lnum - line1 + 1]
			local pat_width_differences = {}
			-- If previewing, only replace the text in current buffer if pat2 isn't empty
			-- Otherwise, always replace the text
			if pat2 ~= "" or not preview then
				if preview then
					for _, line_match in ipairs(line_matches) do
						local startidx, endidx = unpack(line_match)
						local pat_match = line:sub(startidx + 1, endidx)
						pat_width_differences[#pat_width_differences + 1] = #vim.fn.substitute(
							pat_match,
							pat1,
							pat2,
							"g"
						) - #pat_match
					end
				end
				new_lines[lnum] = vim.fn.substitute(line, pat1, pat2, "g")
			end
			-- Highlight the matches if previewing
			if preview then
				local idx_offset = 0
				for i, line_match in ipairs(line_matches) do
					local startidx, endidx = unpack(line_match)
					-- Starting index of replacement text
					local repl_startidx = startidx + idx_offset
					-- Ending index of the replacement text (if pat2 isn't empty)
					local repl_endidx
					if pat2 ~= "" then
						repl_endidx = endidx + idx_offset + pat_width_differences[i]
					else
						repl_endidx = endidx + idx_offset
					end
					if pat2 ~= "" then
						idx_offset = idx_offset + pat_width_differences[i]
					end
					line_matches[i] = { repl_startidx, repl_endidx }
				end
			end
		end
		for lnum, line in pairs(new_lines) do
			vim.api.nvim_buf_set_lines(buf, lnum - 1, lnum, false, { line })
		end
		matches[#matches + 1] = { buf, buf_matches }
	end
	if preview then
		local lnum = vim.api.nvim_win_get_cursor(0)[1]
		-- Use preview window only if preview buffer is provided and range isn't just the current line
		local use_preview_win = (preview_buf ~= nil) and (line1 ~= lnum or line2 ~= lnum)
		return show_replace_preview(use_preview_win, preview_ns, preview_buf, matches)
	end
end

local function replace(opts)
	do_replace(opts, false)
end

local function replace_preview(opts, preview_ns, preview_buf)
	return do_replace(opts, true, preview_ns, preview_buf)
end

-- ":<range>Replace <pat1> <pat2>"
-- Replaces all occurrences of <pat1> in <range> with <pat2>
vim.api.nvim_create_user_command(
	"Replace",
	replace,
	{ nargs = "*", range = "%", addr = "lines", preview = replace_preview }
)
