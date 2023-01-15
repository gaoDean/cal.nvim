local default_config = {
	window = {
		width = 0.8,
		height = 0.8,
		split = 0.3,
		border = "rounded", -- border decoration for example "rounded"(:h nvim_open_win)
	},
}

local M = vim.deepcopy(default_config)

M.update = function(opts)
	local newconf = vim.tbl_deep_extend("force", default_config, opts or {})

	for k, v in pairs(newconf) do
		M[k] = v
	end
end

return M
