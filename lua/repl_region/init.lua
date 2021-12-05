local ts_utils = require("nvim-treesitter.ts_utils")

local M = {}

local get_master_node = function()
	local node = ts_utils.get_node_at_cursor()

	if node == nil then
		error("No Treesitter node found.")
	end

	local parent = node:parent()
	local root = ts_utils.get_root_for_node(node)
	local start_row = node:start()
	while parent ~= nil and parent ~= root and parent:start() == start_row do
		node = parent
		parent = node:parent()
	end

	return node
end

local move_cursor_down = function(cur_row, cur_col)
	-- If on last line, create new line
	if cur_row + 1 == vim.api.nvim_buf_line_count(0) then
		vim.api.nvim_buf_set_lines(0, cur_row + 2, cur_row + 2, false, { "" })
	end

	-- Move down while preserving same col
	vim.api.nvim_win_set_cursor(0, { cur_row + 2, cur_col })
end

M.send_region = function()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local cur_col = cursor[2]
	local bufnr = vim.api.nvim_get_current_buf()
	local node = get_master_node()
	local start_row, _, end_row, end_col = node:range()

	-- Set visual marks and launch neoterm cmd
	vim.api.nvim_buf_set_mark(bufnr, "<", start_row + 1, 0, {})
	vim.api.nvim_buf_set_mark(bufnr, ">", end_row + 1, end_col + 1, {})
	vim.api.nvim_command("TREPLSendSelection")

	move_cursor_down(end_row, cur_col)
end

return M
