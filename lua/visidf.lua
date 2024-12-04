local M = {}

local dap = require("dap")

local running = false

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
  if running then
    vim.notify("Already running", vim.log.levels.ERROR)
    return
  end
	local selected = get_visual_selection()[1]
  os.remove(".visidf")
  dap.repl.execute(selected .. [[.iloc[:0].to_parquet(".visidf")]]) -- test if the dataframe is valid

  local function check_test_df()
		if not io.open(".visidf") then
			vim.notify("Failed to load dataframe", vim.log.levels.ERROR)
			return
		end
    running = true
		os.remove(".visidf")
		dap.repl.execute("import shutil;" .. selected .. [[.to_parquet(".visidf.tmp"); shutil.move(".visidf.tmp", ".visidf")]])

    local retries = 30
    local function check_df()
      if io.open(".visidf") then
        Snacks.terminal(options.vdpath .. " -f parquet .visidf")
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

return M
