local M = {}
local state = require "claude-chat.state"
local utils = require "claude-chat.utils"

function M.setup_terminal_keymaps()
	local state_data = state.get()
	local buf = state_data.buf
	if not buf then
		return
	end

	vim.api.nvim_buf_set_keymap(buf, "n", "q", "", {
		callback = function()
			require("claude-chat").close_chat()
		end,
		noremap = true,
		silent = true,
		desc = "Close Claude chat",
	})

	vim.api.nvim_buf_set_keymap(buf, "n", "i", "i", {
		noremap = true,
		silent = true,
		desc = "Enter insert mode to send message",
	})

	vim.api.nvim_buf_set_keymap(buf, "n", "a", "A", {
		noremap = true,
		silent = true,
		desc = "Enter insert mode at end of line",
	})

	vim.api.nvim_buf_set_keymap(buf, "t", "<C-c>", "", {
		callback = function()
			require("claude-chat").close_chat()
		end,
		noremap = true,
		silent = true,
		desc = "Close Claude chat",
	})

	vim.api.nvim_buf_set_keymap(buf, "t", "<C-f>", "", {
		callback = function()
			if not state_data.job_id then
				return
			end
			local original_win = nil
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				if win ~= state_data.win then
					local buf_id = vim.api.nvim_win_get_buf(win)
					if vim.bo[buf_id].buftype == "" then
						original_win = win
						break
					end
				end
			end
			if original_win then
				vim.api.nvim_set_current_win(original_win)
				local filepath = utils.get_relative_filepath()
				if filepath ~= "" then
					filepath = "File: " .. filepath .. " "
					vim.api.nvim_set_current_win(state_data.win)
					vim.fn.chansend(state_data.job_id, filepath)
				end
			end
		end,
		noremap = true,
		silent = true,
		desc = "Insert current buffer filepath",
	})

	vim.api.nvim_buf_set_keymap(buf, "t", "<C-\\>", "<C-\\><C-N>", {
		noremap = true,
		silent = true,
		desc = "Exit terminal insert mode",
	})
end

return M
