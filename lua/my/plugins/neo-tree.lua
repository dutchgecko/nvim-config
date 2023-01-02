local mymappings = require('my.mappings')
local myutils = require('my.utils')

local M = { 'nvim-neo-tree/neo-tree.nvim' }

M.dependencies = {
  { 'nvim-lua/plenary.nvim' },
  { 'nvim-tree/nvim-web-devicons' },
  { 'MunifTanjim/nui.nvim' },
  {
    's1n7ax/nvim-window-picker',
    config = function()
      require('window-picker').setup({
        autoselect_one = true,
        include_current = false,
        filter_rules = {
          bo = {
            filetype = { 'neo-tree', 'neo-tree-popup', 'notify' },
            buftype = { 'terminal', 'quickfix' },
          }
        },
        other_win_hl_color = '#02abd1',
      })
    end,
  },
}

function M.config()
  vim.g.neo_tree_remove_legacy_commands = 1
  require('neo-tree').setup({
    close_if_last_window = false,
    enable_git_status = true,
    enable_diagnostics = true,
    sort_case_insensitive = true,
    source_selector = { winbar = true },
    window = {
      mappings = {
        [']]'] = 'next_source',
        ['[['] = 'prev_source',
      },
    },
    filesystem = {
      visible = false,
      hide_dotfiles = true,
      hide_gitignored = true,
      hide_hidden = true,
      follow_current_file = true,
      use_libuv_file_watcher = true,
    },
  })
end

M.cmd = { 'Neotree' }

mymappings.add {
  itemgroup = 'neotree',
  description = 'mappings to trigger neo-tree',
  keymaps = {
    {
      '<Leader>te',
      function()
        local cwd = myutils.get_project_root() or ''
        vim.cmd('Neotree toggle reveal ' .. cwd)
      end,
      desc = 'open neo-tree',
    },
  },
}

return M
