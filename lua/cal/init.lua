local config = require("cal.config")

local M = {}

M.setup = function(opts)
	config.update(opts)
	for k, v in pairs(require("cal.main")) do
		M[k] = v
	end
end

return M
