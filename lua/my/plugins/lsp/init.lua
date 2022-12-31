local M = { 'VonHeikemen/lsp-zero.nvim' }

M.dependencies = {
  -- LSP Support
  {'neovim/nvim-lspconfig'},
  {'williamboman/mason.nvim'},
  {'williamboman/mason-lspconfig.nvim'},

  -- Autocompletion
  {'hrsh7th/nvim-cmp'},
  {'hrsh7th/cmp-buffer'},
  {'hrsh7th/cmp-path'},
  {'saadparwaiz1/cmp_luasnip'},
  {'hrsh7th/cmp-nvim-lsp'},
  {'hrsh7th/cmp-nvim-lua'},

  -- Snippets
  {'L3MON4D3/LuaSnip'},
  {'rafamadriz/friendly-snippets'},
}

function M.config()
  local lsp = require('lsp-zero')
  lsp.preset('recommended')

  lsp.on_attach(function(client, bufnr)
    local function kmap(mode, sequence, func)
      local opts = { buffer = bufnr, remap = false }
      vim.keymap.set(mode, sequence, func, opts)
    end

    kmap('i', '<C-k>', vim.lsp.buf.signature_help)
    kmap('n', '<C-k>', vim.lsp.buf.signature_help)
    kmap('n', '<Leader><Leader>', vim.diagnostic.open_float)
    kmap('n', '<Leader>gi', vim.lsp.buf.implementation)
  end)

  require('my.plugins.lsp.sumneko_lua').setup()

  lsp.setup()
end

M.event = 'VeryLazy'

return M
