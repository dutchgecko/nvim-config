local M = { 'mrjones2014/legendary.nvim' }

function M.config()
  require('legendary').setup({
    keymaps = require('my.mappings').keymaps
  })
end

M.event = 'VeryLazy'

return M
