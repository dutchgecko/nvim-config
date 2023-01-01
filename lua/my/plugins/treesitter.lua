local M = { 'nvim-treesitter/nvim-treesitter' }

function M.build()
  vim.cmd('TSUpdate')
end

function M.config()
  require('nvim-treesitter.configs').setup {
    auto_install = true,
    ensure_installed = {
      'lua',
      'javascript',
      'c_sharp',
      'bash',
      'fish',
      'python',
      'html',
      'markdown',
      'sql',
      'typescript',
      'vim',
      'yaml',
    },

    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },

    indent = {
      enable = true,
      disable = {},
    },
  }

  vim.opt.foldmethod = 'expr'
  vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
end

M.event = 'BufReadPre'

return M
