local default_config = {
}

local M = vim.deepcopy(default_config)

M.update = function(opts)
  local newconf = vim.tbl_deep_extend("force", default_config, opts or {})

  for k, v in pairs(newconf) do
    M[k] = v
  end
end

return M
