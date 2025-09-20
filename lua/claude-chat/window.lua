local M = {}
local config = require "claude-chat.config"
local state = require "claude-chat.state"
local keymaps = require "claude-chat.keymaps"

function M.create_chat_window()
	local state_data = state.get()
	if state_data.win and vim.api.nvim_win_is_valid(state_data.win) then
		vim.api.nvim_set_current_win(state_data.win)
		return
	end

	local width = vim.o.columns
	local height = vim.o.lines
	local options = config.get()

	if options.split == "vsplit" then
		local split_width = math.floor(width * options.width)
		if options.position == "right" then
			vim.cmd("botright " .. split_width .. "vsplit")
		else
			vim.cmd("topleft " .. split_width .. "vsplit")
		end
	else
		local split_height = math.floor(height * options.height)
		if options.position == "bottom" then
			vim.cmd("botright " .. split_height .. "split")
		else
			vim.cmd("topleft " .. split_height .. "split")
		end
	end

	local win = vim.api.nvim_get_current_win()
	state.get().win = win
end

function M.setup_file_watcher()
	local state_data = state.get()
	if not state_data.original_buf or not vim.api.nvim_buf_is_valid(state_data.original_buf) then
		return
	end

	state.set_original_updatetime(vim.o.updatetime)
	vim.o.updatetime = 100
	vim.o.autoread = true

	vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI", "FocusGained", "BufEnter" }, {
		callback = function()
			vim.cmd "checktime"
		end,
		desc = "Auto-reload file changes for Claude chat",
	})

	local timer = vim.loop.new_timer()
	timer:start(
		1000,
		1000,
		vim.schedule_wrap(function()
			if state_data.job_id and vim.api.nvim_buf_is_valid(state_data.original_buf) then
				vim.cmd "checktime"
			else
				if timer then
					timer:stop()
					timer:close()
					timer = nil
				end
			end
		end)
	)
	state.set_timer(timer)
end

function M.start_claude_terminal(prompt)
	local current_win = vim.api.nvim_get_current_win()
	local current_buf = vim.api.nvim_get_current_buf()
	state.set_original_context(current_win, current_buf)

	M.create_chat_window()

	local options = config.get()
	local cmd = options.claude_cmd
	if prompt and prompt ~= "" then
		cmd = cmd .. " " .. vim.fn.shellescape(prompt)
	end

	vim.cmd("terminal " .. cmd)
	local buf = vim.api.nvim_get_current_buf()
	local job_id = vim.b.terminal_job_id
	local win = vim.api.nvim_get_current_win()

	state.set_terminal_info(buf, win, job_id)

	vim.bo[buf].bufhidden = "hide"
	vim.bo[buf].buflisted = false
	vim.api.nvim_win_set_option(win, "statusline", " ")

	vim.cmd "stopinsert"

	keymaps.setup_terminal_keymaps()
	M.setup_file_watcher()
end

return M
