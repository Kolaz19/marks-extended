local m = {}

function m.setup(opts)
	if not opts then return end
end

local function reverse_marklist(tab)
	local new_tab = {}
	for i = 1, #tab do
		table.insert(new_tab, tab[#tab + 1 - i])
	end
	return new_tab
end

local function next_mark(lowercase, reverse)
	local ascii_start = 64
	if lowercase then ascii_start = 96 end
	local cur_line = vim.api.nvim_win_get_cursor(0)
	local cur_buffer = vim.api.nvim_get_current_buf()
	local available_marks = {}
	local cur_pos_mark = { mark_name = nil, internal_number = nil }
	--Loop through all letters
	for i = 1, 26 do
		local mark_char = nil
		local mark_pos = {}
		if (lowercase) then
			mark_char = string.char(ascii_start + i)
			mark_pos = vim.api.nvim_buf_get_mark(0, mark_char)
			mark_pos[3] = cur_buffer
		else
			mark_char = string.char(ascii_start + i)
			mark_pos = vim.api.nvim_get_mark(mark_char, {})
		end

		--Does mark exist?
		if mark_pos[1] ~= 0 then
			--Mark on same line as cursor?
			if (mark_pos[1] == cur_line[1] and mark_pos[3] == cur_buffer) then
				cur_pos_mark.mark_name = mark_char
				cur_pos_mark.internal_number = ascii_start + i
			else
				table.insert(available_marks, {
					mark_name = mark_char,
					pos = mark_pos[1],
					buf = mark_pos[3],
					internal_number = (ascii_start + i)
				})
			end
		end
	end

	if reverse then
		available_marks = reverse_marklist(available_marks)
	end

	--Case 1: cursor not on mark
	if cur_pos_mark.mark_name == nil then
		local nearest_mark_same_buffer = { internal_number = nil, diff = 0 }
		--Get nearest mark in buffer in relation to current line
		for _, val in ipairs(available_marks) do
			if val.buf == cur_buffer then
				local diff_lines = 0
				if cur_line[1] > val.pos then
					diff_lines = cur_line[1] - val.pos
				else
					diff_lines = val.pos - cur_line[1]
				end
				if nearest_mark_same_buffer.diff == 0 or diff_lines < nearest_mark_same_buffer.diff then
					nearest_mark_same_buffer.internal_number = val.internal_number
					nearest_mark_same_buffer.diff = diff_lines
				end
			end
		end

		if nearest_mark_same_buffer.internal_number ~= nil then
			--Move to next letter based on nearest mark
			for _, val in ipairs(available_marks) do
				if (not reverse and val.internal_number > nearest_mark_same_buffer.internal_number) or
					(reverse and val.internal_number < nearest_mark_same_buffer.internal_number) then
					vim.cmd("'" .. val.mark_name)
					return
				end
			end
			--No mark bigger -> Just move to different mark
			for _, val in ipairs(available_marks) do
				if val.internal_number ~= nearest_mark_same_buffer.internal_number then
					vim.cmd("'" .. val.mark_name)
					return
				end
			end
		end
		--Otherwise just move to first letter found
		for _, val in ipairs(available_marks) do
			vim.cmd("'" .. val.mark_name)
			return
		end
	else
		--Case 2: Cursor on mark
		--Move to next letter based on mark on current line
		for _, val in ipairs(available_marks) do
			if (not reverse and val.internal_number > cur_pos_mark.internal_number) or
				(reverse and val.internal_number < cur_pos_mark.internal_number) then
				vim.cmd("'" .. val.mark_name)
				return
			end
		end
		--No mark bigger -> Just move to different mark
		for _, val in ipairs(available_marks) do
			if val.internal_number ~= cur_pos_mark.internal_number then
				vim.cmd("'" .. val.mark_name)
				return
			end
		end
	end
end

local function set_next_mark(lowercase)
  local from = lowercase and 'a' or 'A'
  local to = lowercase and 'z' or 'Z'
  for i = string.byte(from), string.byte(to) do
    local mark = string.char(i)

    local pos = vim.fn.getpos("'" .. mark)

    if pos[2] == 0 then
      -- mark at current cursor position
      vim.cmd("mark " .. mark)
      return
    end
  end

  vim.notify("No available global marks (A–Z)", vim.log.levels.WARN)
end

function m.jump_to_next_global_mark()
	next_mark(false, false)
end

function m.jump_to_previous_global_mark()
	next_mark(false, true)
end

function m.jump_to_next_local_mark()
	next_mark(true, false)
end

function m.jump_to_previous_local_mark()
	next_mark(true, true)
end

function m.set_next_local_mark()
	set_next_mark(true)
end

function m.set_next_global_mark()
	set_next_mark(false)
end

return m
