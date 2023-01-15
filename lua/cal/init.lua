local config = require("cal.config")
local os = require("os")

local M = {}

M.setup = function(opts)
	config.update(opts)
end

return M
