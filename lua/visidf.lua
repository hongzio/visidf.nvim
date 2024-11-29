local M = {}

local dap = require("dap")

local options = {
	vdpath = "/usr/local/bin/vd",
}

local function get_visual_selection()
	local _, line_start, col_start = unpack(vim.fn.getpos("v"))
	local _, line_end, col_end = unpack(vim.fn.getpos("."))
	local selection = vim.api.nvim_buf_get_text(0, line_start - 1, col_start - 1, line_end - 1, col_end, {})
	return selection
end

function M.setup(opts)
	options = vim.tbl_extend("force", options, opts or {})
end

function M.run()
	local selected = get_visual_selection()[1]
	dap.repl.execute(string.format([[%s.to_parquet(".visidf")]], selected))
	Snacks.terminal(string.format("%s -f parquet .visidf", options.vdpath))
end

return M
