local M = {}

local dap = require("dap")

local running = false
local visidf_path = vim.fn.getcwd() .. "/.visidf"

local options = {
	vdpath = "vd",
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
	if running then
		vim.notify("Already running", vim.log.levels.ERROR)
		return
	end
	local selected = get_visual_selection()[1]
	local ok, _ = os.remove(visidf_path)
	if ok then
		vim.notify("Removed existing .visidf", vim.log.levels.INFO)
	end

  -- Check if the selected text is a valid dataframe or numpy array
	dap.repl.execute([[
try:
  import pandas as pd
  import numpy as np
  if isinstance(]] .. selected .. [[, pd.DataFrame):
    ]] .. selected .. [[.iloc[:0].to_parquet("]] .. visidf_path .. [[")
  elif isinstance(]] .. selected .. [[, np.ndarray):
    pd.DataFrame(]] .. selected .. [[).iloc[:0].to_parquet(" ]] .. visidf_path .. [[")
except Exception as e:
  print(e)
]])

	local function check_test_df()
		if not io.open(visidf_path) then
			vim.notify("Failed to load dataframe", vim.log.levels.ERROR)
			return
		end
		running = true
		os.remove(".visidf")
		dap.repl.execute([[
try:
  import shutil
  if isinstance(]] .. selected .. [[, pd.DataFrame):
    ]] .. selected .. [[.to_parquet("]] .. visidf_path .. [[.tmp")
  elif isinstance(]] .. selected .. [[, np.ndarray):
    pd.DataFrame(]] .. selected .. [[).to_parquet("]] .. visidf_path .. [[.tmp")
  shutil.move("]] .. visidf_path .. [[.tmp", "]] .. visidf_path .. [[")
except Exception as e:
  print(e)
]])

		local retries = 30
		local function check_df()
			if io.open(".visidf") then
				Snacks.terminal(options.vdpath .. " -f parquet " .. visidf_path)
				running = false
			elseif retries > 0 then
				retries = retries - 1
				vim.defer_fn(check_df, 100)
			else
				vim.notify("Failed to load dataframe", vim.log.levels.ERROR)
				running = false
			end
		end
		vim.notify("Loading dataframe...", vim.log.levels)
		vim.defer_fn(check_df, 100)
	end
	vim.defer_fn(check_test_df, 50)
end

function M.prev()
	Snacks.terminal(options.vdpath .. " -f parquet " .. visidf_path)
end

return M
