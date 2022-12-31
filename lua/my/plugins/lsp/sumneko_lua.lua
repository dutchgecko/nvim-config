local lsp = require('lsp-zero')

local M = {}

function M.setup()
  lsp.configure('sumneko_lua', {
    settings = {
      Lua = {
        diagnostics = {
          globals = { 'vim' },
        },
      },
    },
  })
end

return M
