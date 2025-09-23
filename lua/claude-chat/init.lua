local M = {}

local config = require "claude-chat.config"
local state = require "claude-chat.state"
local context = require "claude-chat.context"
local window = require "claude-chat.window"

function M.setup(opts)
	config.setup(opts)

	-- Set up global keymap if configured
	local options = config.get()
	if options.keymaps.global then
		vim.keymap.set({ "n", "v" }, options.keymaps.global, ":ClaudeChat<CR>", {
			desc = "Toggle Claude Chat",
			silent = true,
		})
	end

	vim.api.nvim_create_user_command("ClaudeChat", function(cmd_opts)
		if cmd_opts.args and cmd_opts.args ~= "" then
			M.ask_claude(cmd_opts.args, cmd_opts.range, cmd_opts.line1, cmd_opts.line2)
		else
			if state.is_session_active() then
				M.toggle_chat_window()
			else
				local ok, input = pcall(vim.fn.input, "Ask Claude: ")
				if not ok then
					return
				end
				M.ask_claude(input, cmd_opts.range, cmd_opts.line1, cmd_opts.line2)
			end
		end
	end, {
		nargs = "?",
		range = true,
		desc = "Ask Claude about the current file or selection",
	})
end

function M.ask_claude(user_input, has_range, line1, line2)
	local ctx = context.get_context(has_range, line1, line2)

	if #user_input == 0 and has_range == 0 then
		window.start_claude_terminal(nil)
		return
	end

	local prompt
	if #user_input == 0 and has_range > 0 and ctx.line_start > 0 then
		prompt = context.format_selection_prompt(ctx)
	else
		prompt = context.format_prompt(ctx, user_input, has_range)
	end

	window.start_claude_terminal(prompt)
end

function M.toggle_chat_window()
	if state.is_window_visible() then
		window.hide_chat_window()
	else
		window.restore_chat_window()
	end
end

function M.close_chat()
	local state_data = state.get()

	if state_data.win and vim.api.nvim_win_is_valid(state_data.win) then
		vim.api.nvim_win_close(state_data.win, true)
	end

	if state_data.job_id then
		vim.fn.jobstop(state_data.job_id)
	end

	state.cleanup_timer()
	state.restore_updatetime()
	state.reset()
end

function M.get_state()
	return state.get()
end

return M
