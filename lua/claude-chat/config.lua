local M = {}

M.defaults = {
	split = "vsplit", -- vsplit, split, or float
	position = "right", -- right, left, top, bottom (ignored for float)
	width = 0.6, -- percentage of screen width (for vsplit or float)
	height = 0.8, -- percentage of screen height (for split or float)
	claude_cmd = "claude", -- command to invoke Claude Code
	float_opts = {
		relative = "editor",
		border = "rounded",
		title = " Claude Chat ",
		title_pos = "center",
	},
}

M.options = {}

function M.setup(opts)
	M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})
end

function M.get()
	return M.options
end

return M
