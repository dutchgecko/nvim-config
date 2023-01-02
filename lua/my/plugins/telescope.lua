local mymappings = require('my.mappings')
local myutils = require('my.utils')

local M = { 'nvim-telescope/telescope.nvim' }

M.dependencies = {
  { 'nvim-lua/plenary.nvim' }
}

M.cmd = {
  'Telescope',
}

local function find_files_in_project(options)
  local opts = options or {}
  opts.cwd = myutils.get_project_root()
  require('telescope.builtin').find_files(opts)
end

local function live_grep_in_project(options)
  local opts = options or {}
  opts.cwd = myutils.get_project_root()
  require('telescope.builtin').live_grep(opts)
end

mymappings.add {
  itemgroup = 'telescope',
  description = 'mappings to trigger telescope',
  keymaps = {
    { '<C-p>', find_files_in_project, desc = 'open files picker' },
    {
      '<Leader><C-p>',
      function() require('telescope.builtin').buffers() end,
      desc = 'open buffers picker',
    },
    {
      '<Leader><C-r>',
      live_grep_in_project,
      desc = 'live grep picker',
    },
    {
      '<Leader><C-o>',
      function() require('telescope.builtin').jumplist() end,
      desc = 'jumplist picker',
    },
  },
}
return M
