local config = require("cal.config")

local M = {}

local function set_autoclose(master_buf_id, master_win_id, slave_win_id)
	vim.api.nvim_create_autocmd("BufLeave", {
		buffer = master_buf_id,
		callback = function() vim.api.nvim_win_close(slave_win_id, true) end,
	})
	vim.keymap.set(
		"n",
		"<C-c>",
		function() vim.api.nvim_win_close(master_win_id, true) end,
		{ buffer = master_buf_id }
	)
	vim.keymap.set(
		"n",
		"<Esc>",
		function() vim.api.nvim_win_close(master_win_id, true) end,
		{ buffer = master_buf_id }
	)
end

local function get_winopts_pair()
	local winopts = {
		height = math.floor(vim.o.lines * config.window.height),
		width = math.floor(vim.o.columns * config.window.width),
	}
	winopts.col = 0.5 * (vim.o.columns - winopts.width) - 1
	winopts.row = 0.5 * (vim.o.lines - winopts.height) - 1

	local master = {
		opts = {
			relative = "editor",
			style = "minimal",
			border = config.window.border,
			height = winopts.height,
			width = math.floor(winopts.width * config.window.split),
			row = winopts.row,
			col = winopts.col,
		},
	}

	local slave = {
		opts = {
			relative = "editor",
			style = "minimal",
			border = config.window.border,
			height = winopts.height,
			width = math.floor(winopts.width * (1 - config.window.split)),
			row = winopts.row,
			col = master.opts.col + master.opts.width + 2,
		},
	}

	return { master = master, slave = slave }
end

function M.create_float_pair()
	local pair = get_winopts_pair()

	pair.slave.buf = vim.api.nvim_create_buf(true, true)
	pair.master.buf = vim.api.nvim_create_buf(true, true)

	pair.slave.win =
		vim.api.nvim_open_win(pair.slave.buf, true, pair.slave.opts)
	pair.slave.win_id = vim.api.nvim_get_current_win()

	pair.master.win =
		vim.api.nvim_open_win(pair.master.buf, true, pair.master.opts)
	pair.master.win_id = vim.api.nvim_get_current_win()

	set_autoclose(pair.master.buf, pair.master.win_id, pair.slave.win_id)

	return pair
end

return M
