local next = next

local M = {}

function M.get_project_root()
  local n, client = next(vim.lsp.get_active_clients())
  if n ~= nil then
    return client.config.root_dir
  end

  if vim.fn.executable('git') then
    local n, project_dir = next(vim.fn.systemlist('git rev-parse --show-toplevel'))
    if n ~= nil and vim.v.shell_error == 0 and project_dir ~= nil then
      return project_dir
    end
  end

  return nil
end

return M
