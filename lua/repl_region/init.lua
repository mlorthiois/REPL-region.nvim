local ts_utils = require("nvim-treesitter.ts_utils")
local api = vim.api

local M = {}

local send_node_to_repl = function(node)
	local start_row, _, end_row, _ = node:range()
	vim.fn["neoterm#repl#line"](start_row + 1, end_row + 1)
end

local move_cursor_down = function(row)
	local num_line = api.nvim_buf_line_count(0)

	-- If on last line, create new line
	if row - 1 == num_line then
		api.nvim_buf_set_lines(0, row, row, false, { "" })
	end

	-- Move down while preserving same col
	api.nvim_win_set_cursor(0, { row, api.nvim_win_get_cursor(0)[2] })
end

local get_non_root_current_node = function()
	local node = ts_utils.get_node_at_cursor()
	if node == nil then
		error("No Treesitter node found.")
	end

	local root = ts_utils.get_root_for_node(node)
	local cursor = api.nvim_win_get_cursor(0)
	local buf_num_lines = api.nvim_buf_line_count(0)

	-- If node is root, move cursor one line below and query new node
	while node:range() == root:range() and cursor[1] ~= buf_num_lines do
		api.nvim_win_set_cursor(0, { cursor[1] + 2, cursor[2] })
		cursor[1] = cursor[1] + 1
		node = ts_utils.get_node_at_cursor()
	end

	-- If at the end of the file and node is root, exit
	if node:range() == root:range() then
		return nil
	end
	return node
end

local get_line_max_parent_node = function(node, root)
	local start_row = node:start()
	local parent = node:parent()
	while parent ~= nil and parent ~= root and parent:start() == start_row do
		node = parent
		parent = node:parent()
	end
	return node
end

local get_not_root_parent_node = function(node, root)
	local parent = node:parent()
	while parent ~= nil and parent ~= root do
		node = parent
		parent = node:parent()
	end
	return node
end

M.send_repl_statement = function(mode)
	local node = get_non_root_current_node()
	local root = ts_utils.get_root_for_node(node)

	if mode == "line" then
		node = get_line_max_parent_node(node, root)
	elseif mode == "global" then
		node = get_not_root_parent_node(node, root)
	else
		error("Mode unknown")
	end

	if node ~= nil then
		send_node_to_repl(node)
		move_cursor_down(node:end_() + 2)
	end
end

return M
