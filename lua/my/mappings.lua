-- This file generates a table of mappings to be passed to legendary.nvim
local insert = table.insert

local M = {}
M.keymaps = {}

function M.add(mapping)
  insert(M.keymaps, mapping)
end

local add = M.add

add { '<C-h>', vim.cmd.nohlsearch, desc = ':nohlsearch - clear search highlight' }

add { '<Leader>y', '"+y', desc = 'yank to system clipboard' }
add { '<Leader>d', '"+d', desc = 'delete to system clipboard' }
add { '<Leader>p', '"+p', desc = 'paste from system clipboard' }
add { '<Leader>P', '"+P', desc = 'paste above from system clipboard' }

add {
  '<Leader>se',
  function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = 'en_gb'
  end,
  desc = 'enable spelling EN_GB',
}
add {
  '<Leader>su',
  function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = 'en_us'
  end,
  desc = 'enable spelling EN_US',
}
add {
  '<Leader>sd',
  function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = 'nl'
  end,
  desc = 'enable spelling NL',
}

add { '<C-j>', 'o<Esc>', desc = 'insert new blank line in normal mode' }

return M
