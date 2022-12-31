local M = {}
function M.setup()
  vim.opt.hidden = true
  vim.opt.showtabline = 2
  vim.opt.laststatus = 2
  vim.opt.showmode = false
  vim.opt.updatetime = 100
  vim.opt.mouse = 'a'

  vim.opt.undodir = vim.fn.stdpath('state') .. 'undodir'
  vim.opt.undofile = true

  vim.opt.number = true
  vim.opt.relativenumber = true
  vim.opt.scrolloff = 8

  vim.opt.signcolumn = 'yes'

  vim.opt.wrap = true
  vim.opt.linebreak = true
  vim.opt.showbreak = ' => '
  vim.opt.list = true
  vim.opt.listchars = {
    tab = 'ﲖﲒ',
    trail = '■',
    extends = '',
    precedes = '',
  }

  vim.opt.foldlevel = 999

  vim.opt.showmatch = true
  vim.opt.hlsearch = true
  vim.opt.incsearch = true
  vim.opt.inccommand = 'split'

  vim.opt.modeline = true

  vim.opt.expandtab = true
  vim.opt.tabstop = 4
  vim.opt.shiftwidth = 4
  vim.opt.smartindent = true

  vim.opt.textwidth = 0
  vim.opt.colorcolumn = { 100, 120 }

  vim.opt.virtualedit = { 'block' }
end

return M
