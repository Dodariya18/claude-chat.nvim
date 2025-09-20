-- claude-chat.nvim
-- Plugin entry point

if vim.g.loaded_claude_chat then
	return
end
vim.g.loaded_claude_chat = 1

-- Check if Claude CLI is available
if vim.fn.executable "claude" == 0 then
	vim.notify("claude-chat.nvim: 'claude' command not found in PATH", vim.log.levels.WARN)
end
