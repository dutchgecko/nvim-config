"#############################################################################
"### Variables for use within this vimrc                            {{{1    ##
"#############################################################################
let g:vimdir = split(&runtimepath, ',')[0]

augroup myvimrc
    autocmd!
augroup END

"#############################################################################
"### Plugin installation                                            {{{1    ##
"#############################################################################
" Load vim-plug         {{{2
if empty(glob(g:vimdir . '/autoload/plug.vim'))
  execute '!curl -fLo ' . g:vimdir . '/autoload/plug.vim --create-dirs ' .
    \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(g:vimdir . '/plugged')

" Lua                   {{{2
Plug 'nvim-lua/plenary.nvim'

" Colorschemes          {{{2
Plug 'sainnhe/sonokai'

" Interface             {{{2
Plug 'famiu/feline.nvim'
Plug 'edkolev/promptline.vim'
Plug 'hoov/tmuxline.vim'
Plug 'akinsho/nvim-bufferline.lua'

" File management       {{{2
Plug 'ctrlpvim/ctrlp.vim'
Plug 'kyazdani42/nvim-tree.lua'

" Version control       {{{2
Plug 'tpope/vim-fugitive'
Plug 'lewis6991/gitsigns.nvim'
Plug 'rbong/vim-flog'

" Languages             {{{2
Plug 'plasticboy/vim-markdown'
Plug 'dag/vim-fish'
Plug 'chr4/nginx'
Plug 'Vimjas/vim-python-pep8-indent'

" Compilers             {{{2
Plug 'CarloDePieri/pytest-vim-compiler'

" Editing               {{{2
Plug 'kshenoy/vim-signature'
Plug 'godlygeek/tabular'

" Motions and text objects {{{2
Plug 'tmhedberg/matchit'
Plug 'michaeljsmith/vim-indent-object'
Plug 'christoomey/vim-sort-motion'
Plug 'tpope/vim-surround'
Plug 'wellle/targets.vim'
Plug 'kana/vim-textobj-user'
Plug 'jceb/vim-textobj-uri'
Plug 'lucapette/vim-textobj-underscore'

" Smarts                {{{2
Plug 'neovim/nvim-lspconfig'
Plug 'tpope/vim-dispatch'
Plug 'radenling/vim-dispatch-neovim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/playground'
"Plug 'hrsh7th/nvim-compe'
"Plug 'onsails/lspkind-nvim'
Plug 'alexaandru/nvim-lspupdate'
"Plug 'liuchengxu/vista.vim'
Plug 'norcalli/nvim-colorizer.lua'

" Usability             {{{2
Plug 'Konfekt/FastFold'
Plug 'tpope/vim-obsession'

" Pretties              {{{2
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'kyazdani42/nvim-web-devicons'

" External stuff        {{{2
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }

call plug#end()

"#############################################################################
"### Default file options                                           {{{1    ##
"#############################################################################
" Tabs                  {{{2
set expandtab
set smarttab
set tabstop=4
set shiftwidth=4

"#############################################################################
"### Default vim options for prettiness and usability               {{{1    ##
"#############################################################################
syntax enable
set smartindent
filetype plugin indent on

set number
set relativenumber

set textwidth=0
set scrolloff=10
set showmatch
set hlsearch
set hidden
set showtabline=2
set laststatus=2
set noshowmode

set noincsearch
set inccommand=split

set linebreak
let &showbreak=' ﬌  '
set list
let &listchars='tab: ,trail:·,extends:,precedes:'
set colorcolumn=80,88,120

set foldlevel=999
set foldmethod=indent

set virtualedit=block,insert

set modeline

set updatetime=100

set mouse=a

set termguicolors
set background=dark
let g:sonokai_style = 'atlantis'
let g:sonokai_enable_italic = 1
colorscheme sonokai

"#############################################################################
"### Colorscheme and highlighting adjustments                       {{{1    ##
"#############################################################################
highlight link TSConstructor TSType
highlight link TSPunctBracket Purple
highlight link TSPunctSpecial Purple
"highlight link TSType Blue
highlight link TSParameter Orange
highlight link TSParameterReference Orange
highlight link TSProperty Purple

if !has('gui')
    highlight ErrorText cterm=italic gui=italic
    highlight WarningText cterm=italic gui=italic
    highlight InfoText cterm=italic gui=italic
    highlight HintText cterm=italic gui=italic
endif

"#############################################################################
"### GUI Settings                                                   {{{1    ##
"#############################################################################
let &guifont = 'JetBrainsMono Nerd Font:h12'
let g:neovide_refresh_rate = 165
let g:neovide_cursor_animation_length = 0.04

"#############################################################################
"### Installed tools                                                {{{1    ##
"#############################################################################
if executable('rg')
    let &grepprg = "rg --vimgrep"
endif

if filereadable(expand('$HOME/.pyenv/versions/neovim/bin/python'))
    let g:python3_host_prog = expand('$HOME/.pyenv/versions/neovim/bin/python')
endif

"#############################################################################
"### Tag handling                                                   {{{1    ##
"#############################################################################
set tags=./tags;/       " search in parent directories for tags file

"#############################################################################
"### Mappings                                                       {{{1    ##
"#############################################################################
nnoremap <leader>te <cmd>NvimTreeToggle<cr>
nnoremap <leader>tl :Vista!!<cr>

nnoremap <silent> <C-h> :nohlsearch<CR>
nnoremap <C-J> o<ESC>

inoremap <C-l> <C-o><C-l>

nnoremap <F5> :Make<CR>

nnoremap <leader>se :setlocal spell spelllang=en_gb<CR>
nnoremap <leader>sd :setlocal spell spelllang=nl<CR>

" hotkey to change diff commit for vim-gitgutter
function GitDiffBase()
    call inputsave()
    let g:gitgutter_diff_base = input('Commit hash: ')
    call inputrestore()
    GitGutterAll
endfunction
nnoremap <leader>gd :call GitDiffBase()<CR>

" Yank to clipboard, place filename on clipboard
if has('clipboard') || has('xterm_clipboard')
    noremap <leader>y "+y
    noremap <leader>d "+d

    nnoremap <leader>f :let @+=expand('%')<CR>
    nnoremap <leader>F :let @+=expand('%:p')<CR>
endif

"### Plugin mappings
nnoremap <leader>w :AirlineToggleWhitespace<CR>
nnoremap <leader><C-P> :CtrlPBuffer<CR>
nnoremap <leader>pp :CtrlPBuffer<CR>
nnoremap <leader><C-T> :CtrlPTag<CR>
nnoremap <leader>tt :CtrlPTag<CR>
nnoremap <leader>bt :CtrlPBufTag<CR>

nnoremap gp     <Plug>ReplaceWithRegisterOperator
nnoremap gpp    <Plug>ReplaceWithRegisterLine
xnoremap gp     <Plug>ReplaceWithRegisterVisual


"### Autocompletion mappings
" When enter is pressed, select option and insert return
"inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

" Use tab to cycle through options
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

"#############################################################################
"### Plugin settings                                                {{{1    ##
"#############################################################################


"### Promptline ###         {{{2
let g:promptline_theme = 'airline'
silent! let g:promptline_preset = {
            \'a' : [ '$FISH_BIND_MODE' ],
            \'b' : [ promptline#slices#user() ],
            \'c' : [ promptline#slices#cwd() ],
            \'warn' : [ promptline#slices#last_exit_code() ],
            \'x' : [ promptline#slices#git_status() ],
            \'y' : [ promptline#slices#vcs_branch() ],
            \'z' : [ promptline#slices#python_virtualenv() ]}

"### IndentLine ###         {{{2
let g:indentLine_char = '┊'
let g:indentLine_bufTypeExclude = ['help', 'terminal']

"### Ctrl-P ###             {{{2
" Use rust tool fd if available
if executable('fd')
    let g:ctrlp_user_command = 'fd --type f --color never "" %s'
    let g:ctrlp_use_caching = 0
endif

"### Firenvim ###           {{{2
let g:firenvim_config = {
            \ 'globalSettings': {
                \ '<C-w>': 'noop',
            \ },
            \ 'localSettings': {
                \ '.*': {
                    \ 'cmdline': 'firenvim',
                    \ 'priority': 0,
                    \ 'selector': 'textarea:not([readonly]), div[role="textbox"]',
                    \ 'takeover': 'always',
                \ },
                \ 'https?://(www\.)?twitch\.tv/': {
                    \ 'selector': 'textarea:not([readonly]):not([class="tw-textarea--no-resize"])',
                    \ 'takeover': 'never',
                    \ 'priority': 10,
                \ },
                \ 'https?://docs.google.com/': {
                    \ 'takeover': 'never',
                    \ 'priority': 10,
                \ },
            \ }
        \ }

function! s:IsFirenvimActive(event) abort
    if !exists('*nvim_get_chan_info')
        return 0
    endif
    let l:ui = nvim_get_chan_info(a:event.chan)
    return has_key(l:ui, 'client') &&
                \ has_key(l:ui.client, 'name') &&
                \ l:ui.client.name =~? 'Firenvim'
endfunction

function! OnUIEnterFirenvim(event) abort
    if s:IsFirenvimActive(a:event)
        " Place settings here
        set laststatus=0
        set scrolloff=0
        set showtabline=0
        let &guifont = 'JetBrainsMono Nerd Font:h9'
    endif
endfunction

autocmd UIEnter * call OnUIEnterFirenvim(deepcopy(v:event))

autocmd myvimrc BufEnter *reddit.com_*.txt set filetype=markdown
autocmd myvimrc BufEnter *github.com_*.txt set filetype=markdown

"### Gitgutter ###           {{{2
let g:gitgutter_sign_priority = 1

"### nvim-tree ###              {{{2
let g:nvim_tree_indent_markers = 1
lua require('plugins.nvim-tree')

"### Vista.vim ###               {{{2
let g:vista_executive_for = {
    \ 'sh': 'nvim_lsp',
    \ 'c': 'nvim_lsp',
    \ 'cpp': 'nvim_lsp',
    \ 'cmake': 'nvim_lsp',
    \ 'css': 'nvim_lsp',
    \ 'dockerfile': 'nvim_lsp',
    \ 'html': 'nvim_lsp',
    \ 'php': 'nvim_lsp',
    \ 'json': 'nvim_lsp',
    \ 'python': 'nvim_lsp',
    \ 'rust': 'nvim_lsp',
    \ 'sql': 'nvim_lsp',
    \ 'lua': 'nvim_lsp',
    \ 'tex': 'nvim_lsp',
    \ 'js': 'nvim_lsp',
    \ 'yaml': 'nvim_lsp',
    \ 'vim': 'ctags',
    \ 'markdown': 'toc',
\ }

let g:vista#renderer#enable_icon = 1
let g:vista_icon_indent = ["╰─ ", "├─ "]
let g:vista_echo_cursor_strategy = 'floating_win'

"### pytest-vim-compiler ###            {{{2
let g:pytest_compiler_args = '--vim-quickfix'

"### Hexokinase ###
let g:Hexokinase_highlighters = ['virtual']

"#############################################################################
"### Lua plugin setup                                               {{{1    ##
"#############################################################################
lua require('gitsigns').setup({signs = {changedelete = {text = '╞'}}})

lua << EOF
if not require'nvim-web-devicons'.has_loaded() then
    require'nvim-web-devicons'.setup()
end
EOF

lua require('plugins.feline')

lua << EOF
require('bufferline').setup{
    options = {
        view = "multiwindow",
        numbers = function(opts)
            return string.format('%s ', opts.id)
        end,
        diagnostics = "nvim_lsp",
        custom_filter = function(bufnr)
            if vim.bo[bufnr].filetype ~= "qf" then
                return true
            end
            return false
        end,
        offsets = {{
            filetype = "NvimTree",
            text = "Files",
            text_align = "left",
        }},
    }
}
EOF

lua require'colorizer'.setup()

"#############################################################################
"### Functions                                                      {{{1    ##
"#############################################################################

function! TableFormat()
    let l:pos = getpos('.')
    normal! {
    " Search instead of `normal! j` because of the table at beginning of file edge case.
    call search('|')
    normal! j
    " Remove everything that is not a pipe, colon or hyphen next to a colon othewise
    " well formated tables would grow because of addition of 2 spaces on the separator
    " line by Tabularize /|.
    let l:flags = (&gdefault ? '' : 'g')
    execute 's/\(:\@<!-:\@!\|[^|:-]\)//e' . l:flags
    execute 's/--/-/e' . l:flags
    Tabularize /|
    " Move colons for alignment to left or right side of the cell.
    execute 's/:\( \+\)|/\1:|/e' . l:flags
    execute 's/|\( \+\):/|:\1/e' . l:flags
    execute 's/ /-/' . l:flags
    call setpos('.', l:pos)
endfunction

command! TableFormat call TableFormat()

"#############################################################################
"### LSP Configuration import                                       {{{1    ##
"#############################################################################
"
"### completion
"set completeopt=menu,menuone,noselect
"let g:compe = {}
"let g:compe.enabled = v:true
"
"let g:compe.source = {}
"let g:compe.source.path = {'menu': ''}
"let g:compe.source.buffer = {'menu': ''}
"let g:compe.source.nvim_lsp = {'menu': ''}
"let g:compe.source.nvim_lua = {'menu': ''}
"let g:compe.source.treesitter = {'menu': ''}
"let g:compe.source.vsnip = v:false
"let g:compe.source.tags = v:false
"
"inoremap <silent><expr> <C-Space> compe#complete()
"inoremap <silent><expr> <CR> compe#confirm('<CR>')
"inoremap <silent><expr> <C-e> compe#close('<C-e>')

"### diagnostics            {{{2
let g:diagnostic_enable_virtual_text = 1
let g:diagnostic_virtual_text_prefix = ''

call sign_define("DiagnosticSignError", {"text": "", "texthl": "DiagnosticSignError"})
call sign_define("DiagnosticSignWarn", {"text": "", "texthl": "DiagnosticSignWarn"})
call sign_define("DiagnosticSignInfo", {"text": "", "texthl": "DiagnosticSignInfo"})
call sign_define("DiagnosticSignHint", {"text": "", "texthl": "DiagnosticSignHint"})

nnoremap ]d <cmd>lua vim.diagnostic.goto_next { wrap = false }<CR>
nnoremap [d <cmd>lua vim.diagnostic.goto_prev { wrap = false }<CR>
nnoremap <leader><leader> <cmd>lua vim.diagnostic.open_float()<CR>

function LspLoadPlugins()
    lua require'nvim-lsp-config'.do_setup()
    lua require'nvim-lsp-config'.setup_handlers()
endfunction

call LspLoadPlugins()

command LspActive lua print(vim.lsp.buf.server_ready())
command LspClientInfo lua print(vim.inspect(vim.lsp.buf_get_clients()))
command LspClear lua vim.lsp.diagnostic.clear(0)

function OpenDiagnostics()
    lua vim.lsp.diagnostic.set_loclist()
    lopen
endfunction
command Diagnostics call OpenDiagnostics()

"#############################################################################
"### Treesitter Configuration import                                {{{1    ##
"#############################################################################
lua require'nvim-treesitter-config'

function UseTreesitterFolding()
    if luaeval('require"nvim-treesitter.parsers".has_parser()')
        setlocal foldmethod=expr
        setlocal foldexpr=nvim_treesitter#foldexpr()
    endif
endfunction

autocmd myvimrc BufEnter * call UseTreesitterFolding()

" vim: set fdm=marker: "
