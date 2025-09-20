local M = {}

M.defaults = {
	split = "vsplit", -- vsplit or split
	position = "right", -- right, left, top, bottom
	width = 0.4, -- percentage of screen width (for vsplit)
	height = 0.4, -- percentage of screen height (for split)
	claude_cmd = "claude", -- command to invoke Claude Code
}

M.options = {}

function M.setup(opts)
	M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})
end

function M.get()
	return M.options
end

return M
