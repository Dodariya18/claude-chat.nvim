---@class FloatOpts
---@field relative string
---@field border string
---@field title string
---@field title_pos string

---@class TerminalKeymaps
---@field close string
---@field toggle string
---@field normal_mode string
---@field insert_file string
---@field interrupt string

---@class Keymaps
---@field global string
---@field terminal TerminalKeymaps

---@class Config
---@field split string vsplit|split|float
---@field position string right|left|top|bottom
---@field width number
---@field height number
---@field claude_cmd string
---@field float_opts FloatOpts
---@field keymaps Keymaps
