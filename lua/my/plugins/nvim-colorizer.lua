local M = { 'NvChad/nvim-colorizer.lua' }

function M.config()
  require('colorizer').setup({
    user_default_options = {
      mode = 'virtualtext',
      css = true,
    },
    filetypes = {
      '*',
      '!gitcommit',
    },
  })
end

M.event = 'BufReadPre'

return M
