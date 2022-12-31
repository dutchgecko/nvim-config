local function currymap(mode)
  return function(lhs, rhs, opts) vim.keymap.set(mode, lhs, rhs, opts) end
end

local nmap = currymap('n')
local imap = currymap('i')
local vmap = currymap('v')
local nvmap = currymap({ 'n', 'v' })

local M = {}
M.nmap = nmap
M.imap = imap
M.vmap = vmap
M.nvmap = nvmap

function M.setup()
  nmap('<C-h>', vim.cmd.nohlsearch, {
    silent = true,
    desc = ':nohlsearch - clear search highlight',
  })

  nvmap(
    '<Leader>y',
    '"+y',
    { desc = 'yank to system clipboard' }
  )
  nvmap(
    '<Leader>d',
    '"+d',
    { desc = 'delete to system clipboard' }
  )
  nvmap(
    '<Leader>p',
    '"+p',
    { desc = 'paste from system clipboard' }
  )
  nvmap(
    '<Leader>P',
    '"+P',
    { desc = 'paste above from system clipboard' }
  )

  nmap(
    '<Leader>se',
    function()
      vim.opt_local.spell = true
      vim.opt_local.spelllang = 'en_gb'
    end,
    { desc = 'enable spelling EN_GB' }
  )
  nmap(
    '<Leader>su',
    function()
      vim.opt_local.spell = true
      vim.opt_local.spelllang = 'en_us'
    end,
    { desc = 'enable spelling EN_US' }
  )
  nmap(
    '<Leader>sd',
    function()
      vim.opt_local.spell = true
      vim.opt_local.spelllang = 'nl'
    end,
    { desc = 'enable spelling NL' }
  )

  nmap('<C-j>', 'o<Esc>', { desc = 'insert new blank line in normal mode' })
end

return M
