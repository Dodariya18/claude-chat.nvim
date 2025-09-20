local M = {}

function M.get_relative_filepath()
	local filepath = vim.fn.expand "%:p"
	if filepath == "" then
		return ""
	end

	local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
	if vim.v.shell_error == 0 and git_root and git_root ~= "" then
		local relative_path =
			vim.fn.fnamemodify(filepath, ":s?" .. vim.fn.escape(git_root, "/?") .. "/??")
		return relative_path
	else
		return vim.fn.expand "%:t"
	end
end

return M
