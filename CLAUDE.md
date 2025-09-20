# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Code Formatting
- `stylua .` - Format Lua code using StyLua with project configuration (.stylua.toml)

### Testing
- No formal test suite exists currently - manual testing by loading plugin in Neovim

### Running the Plugin
- Install in Neovim with plugin manager (lazy.nvim recommended)
- Test with `:ClaudeChat` command or configured keybinding

## Architecture Overview

This is a Neovim plugin written in Lua that provides an interface to Claude Code CLI directly within Neovim. The plugin creates a terminal split and passes context about the current file and any text selections to Claude.

### Core Components

**Main Entry Point (`lua/claude-chat/init.lua`)**
- Plugin setup and user command registration
- Main `ask_claude()` function that orchestrates the chat flow
- Handles different input scenarios (no prompt, with selection, etc.)

**Configuration (`lua/claude-chat/config.lua`)**
- Plugin configuration management with sensible defaults
- Configurable split direction, position, sizing, and Claude command

**State Management (`lua/claude-chat/state.lua`)**
- Centralized state for terminal window, buffer, job ID, and original context
- Cleanup utilities for timers and settings restoration

**Context Gathering (`lua/claude-chat/context.lua`)**
- Extracts file context (path, line ranges) for text selections
- Formats prompts with file information and user queries
- Handles different prompt scenarios (selection-only, query+context, etc.)

**Window Management (`lua/claude-chat/window.lua`)**
- Creates and positions terminal splits based on configuration
- Sets up file watching for live context updates
- Starts Claude terminal with optional initial prompt

**Keybindings (`lua/claude-chat/keymaps.lua`)**
- Terminal-specific keybindings (`q` to close, `<C-f>` to insert filepath)
- Manages both normal and terminal mode mappings

**Utilities (`lua/claude-chat/utils.lua`)**
- Helper functions like getting relative file paths from git root

### Plugin Behavior Logic

The plugin behaves differently based on user input and text selection:

1. **No prompt + No selection**: Opens plain Claude terminal
2. **No prompt + Text selected**: Sends selection with file context
3. **With prompt + No selection**: Sends prompt with current file context
4. **With prompt + Text selected**: Sends both prompt and selection context

### Key Features

- **Context Injection**: Automatically passes current file path, filetype, and line ranges to Claude
- **Live File Watching**: Updates `updatetime` and sets up autocmds for file change detection
- **Terminal Integration**: Uses Neovim's built-in terminal with custom keybindings
- **Flexible Positioning**: Configurable split direction and positioning (vsplit/split, right/left/top/bottom)

### File Structure

```
plugin/claude-chat.lua          # Plugin entry point, checks for Claude CLI
lua/claude-chat/
├── init.lua                    # Main plugin logic and setup
├── config.lua                  # Configuration management
├── state.lua                   # State management
├── context.lua                 # Context gathering and prompt formatting
├── window.lua                  # Window/terminal management
├── keymaps.lua                 # Terminal keybindings
└── utils.lua                   # Utility functions
```

## Important Notes

- Plugin requires Claude Code CLI installed and available in PATH as `claude`
- Uses Neovim's job control API for terminal management
- State cleanup is important to avoid resource leaks (timers, jobs, autocmds)
- Context formatting preserves file paths and line numbers for Claude reference