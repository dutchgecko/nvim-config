local M = { 'EdenEast/nightfox.nvim' }

M.lazy = false
M.priority = 1000

function M.config()
  vim.opt.termguicolors = true
  vim.cmd('colorscheme nightfox')
end

return M
