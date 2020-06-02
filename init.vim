let g:vimdir = split(&runtimepath, ',')[0]
call plug#begin(g:vimdir . '/plugged')

Plug 'sainnhe/sonokai'
Plug 'neovim/nvim-lsp'

call plug#end()

syntax enable
filetype plugin indent on

set termguicolors
colorscheme sonokai

function LspLoadPlugins()
    lua require'nvim-lsp-config'.do_setup()
endfunction

call LspLoadPlugins()

command LspActive lua print(vim.lsp.buf.server_ready())
command LspClientInfo lua print(vim.inspect(vim.lsp.buf_get_clients()))

" vim: set fdm=marker: "
