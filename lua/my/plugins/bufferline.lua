local M = { 'akinsho/bufferline.nvim' }

M.dependencies = { { 'nvim-tree/nvim-web-devicons' } }

function M.config()
  require('bufferline').setup({
    options = {
      view = 'multiwindow',
      numbers = function(opts)
        return string.format('%s ', opts.id)
      end,
      diagnostics = 'nvim_lsp',
      custom_filter = function(bufnr)
        return vim.bo[bufnr].filetype ~= 'qf'
      end,
      offsets = {
        {
          filetype = 'NvimTree',
          text = 'Files',
          text_align = 'left',
        },
      },
    },
  })
end

return M
