local M = { 'lukas-reineke/indent-blankline.nvim' }

function M.config()
  require('indent_blankline').setup({
    show_current_context = true,
  })
end

M.event = 'BufReadPre'

return M
