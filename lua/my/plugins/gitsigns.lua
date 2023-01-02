local M = { 'lewis6991/gitsigns.nvim' }

function M.config()
  local gs = require('gitsigns')
  require('gitsigns').setup({
    on_attach = function(bufnr)
      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      map('n', ']c',
        function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end,
        { expr = true })

      map('n', '[c',
        function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end,
        { expr = true })
    end
  })
end

M.event = 'BufReadPre'

return M
