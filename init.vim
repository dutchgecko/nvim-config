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

" Colorschemes          {{{2
Plug 'morhetz/gruvbox'
Plug 'sainnhe/sonokai'

" Interface             {{{2
Plug 'vim-airline/vim-airline'
Plug 'edkolev/promptline.vim'
"Plug 'edkolev/tmuxline.vim'
Plug 'hoov/tmuxline.vim'

" File management       {{{2
Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/nerdtree'

" Version control       {{{2
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'rbong/vim-flog'

" Tags                  {{{2
if executable('ctags')
    Plug 'majutsushi/tagbar'
    Plug 'ludovicchabant/vim-gutentags'
endif

" Languages             {{{2
Plug 'plasticboy/vim-markdown'
Plug 'kh3phr3n/python-syntax'
Plug 'dag/vim-fish'

" Editing               {{{2
Plug 'vim-scripts/ReplaceWithRegister'
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
" Plug 'w0rp/ale'
Plug 'neovim/nvim-lsp'
Plug 'nvim-lua/completion-nvim'
Plug 'weilbith/nvim-lsp-smag'
Plug 'wbthomason/lsp-status.nvim'
Plug 'tpope/vim-dispatch'
Plug 'radenling/vim-dispatch-neovim'
Plug 'nvim-treesitter/nvim-treesitter'

" Usability             {{{2
Plug 'Konfekt/FastFold'
Plug 'tpope/vim-obsession'

" Pretties              {{{2
Plug 'Yggdroot/indentLine'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'ryanoasis/vim-devicons'

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
set colorcolumn=81,121

set foldlevel=999
set foldmethod=indent

set virtualedit=block,insert

set modeline

set updatetime=800

set mouse=a

set termguicolors
set background=dark
let g:sonokai_style = 'atlantis'
colorscheme sonokai

"#############################################################################
"### Colorscheme and highlighting adjustments                       {{{1    ##
"#############################################################################
highlight link TSVariable Orange
highlight link TSPunctBracket Purple
highlight link TSPunctSpecial Purple

"#############################################################################
"### GUI Settings                                                   {{{1    ##
"#############################################################################
let &guifont = 'JetBrainsMono Nerd Font Mono:h12'
let g:neovide_refresh_rate = 165
let g:neovide_cursor_animation_length = 0.04

"#############################################################################
"### Installed tools                                                {{{1    ##
"#############################################################################
if executable('rg')
    let &grepprg = "rg --vimgrep"
endif

"#############################################################################
"### Tag handling                                                   {{{1    ##
"#############################################################################
set tags=./tags;/       " search in parent directories for tags file

"#############################################################################
"### Mappings                                                       {{{1    ##
"#############################################################################
nnoremap <leader>te :NERDTreeToggle<cr>
nnoremap <leader>tl :TagbarToggle<cr>

nnoremap <silent> <C-h> :nohlsearch<CR>
nnoremap <C-J> o<ESC>

inoremap <C-l> <C-o><C-l>

nnoremap <F5> :make<CR>

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

"### Airline ###            {{{2
let g:airline_powerline_fonts = 1
let g:airline#extensions#whitespace#enabled = 0

" Display buffers in tabline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

" Custom icon for vim-obsession
let g:airline#extensions#obsession#indicator_text = ''
" Remove icon for total number of lines in buffer
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.maxlinenr = ''

" Don't auto-invoke Tmuxline
let g:airline#extensions#tmuxline#enabled = 0

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
let g:indentLine_char = ''
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
        let &guifont = 'JetBrainsMono Nerd Font Mono:h10'
    endif
endfunction

autocmd UIEnter * call OnUIEnterFirenvim(deepcopy(v:event))

autocmd myvimrc BufEnter *reddit.com_*.txt set filetype=markdown
autocmd myvimrc BufEnter *github.com_*.txt set filetype=markdown

"### Gitgutter ###           {{{2
let g:gitgutter_sign_priority = 1

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
"### completion-nvim        {{{2
autocmd myvimrc BufEnter * lua require'completion'.on_attach()

inoremap <silent> <C-Space> <Plug>(completion_trigger)

set completeopt=menuone,noselect,noinsert
set shortmess+=c

let g:completion_enable_auto_popup = 1
let g:completion_enable_auto_hover = 1
let g:completion_enable_auto_signature = 1
let g:completion_auto_change_source = 1

let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy', 'all']
let g:completion_matching_smart_case = 1

"### diagnostics            {{{2
let g:diagnostic_enable_virtual_text = 1
let g:diagnostic_virtual_text_prefix = ''

augroup myvimrc
    autocmd BufEnter * let g:completion_trigger_character = ['.']
    autocmd BufEnter *.c,*.cpp let g:completion_trigger_character = ['.', '::']
augroup end

call sign_define("LspDiagnosticsSignError", {"text": "", "texthl": "LspDiagnosticsSignError"})
call sign_define("LspDiagnosticsSignWarning", {"text": "", "texthl": "LspDiagnosticsSignWarning"})
call sign_define("LspDiagnosticsSignInformation", {"text": "", "texthl": "LspDiagnosticsSignInformation"})
call sign_define("LspDiagnosticsSignHint", {"text": "ﯟ", "texthl": "LspDiagnosticsSignHint"})

nnoremap ]d <cmd>lua vim.lsp.diagnostic.goto_next { wrap = false }<CR>
nnoremap [d <cmd>lua vim.lsp.diagnostic.goto_prev { wrap = false }<CR>

function LspLoadPlugins()
    lua require'nvim-lsp-config'.do_setup()
    lua require'nvim-lsp-config'.setup_handlers()
endfunction

call LspLoadPlugins()

command LspActive lua print(vim.lsp.buf.server_ready())
command LspClientInfo lua print(vim.inspect(vim.lsp.buf_get_clients()))

function OpenDiagnostics()
    lua vim.lsp.diagnostic.set_loclist()
    lopen
endfunction
command Diagnostics call OpenDiagnostics()

"#############################################################################
"### Treesitter Configuration import                                {{{1    ##
"#############################################################################
lua require'nvim-treesitter-config'

" highlighting
highlight! link TSConstructor TSType

" vim: set fdm=marker: "
