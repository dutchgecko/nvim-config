"#############################################################################
"### Variables for use within this vimrc                            {{{1    ##
"#############################################################################
let s:vimdir = split(&runtimepath, ',')[0]

augroup myvimrc
    autocmd!
augroup END

"#############################################################################
"### Plugin installation                                            {{{1    ##
"#############################################################################
" Load vim-plug         {{{2
if empty(glob(s:vimdir . '/autoload/plug.vim'))
  execute '!curl -fLo ' . s:vimdir . '/autoload/plug.vim --create-dirs ' .
    \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(s:vimdir . '/plugged')

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
Plug 'sheerun/vim-polyglot'

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
Plug 'haorenW1025/completion-nvim'
Plug 'haorenW1025/diagnostic-nvim'
Plug 'weilbith/nvim-lsp-smag'
Plug 'tpope/vim-dispatch'
Plug 'radenling/vim-dispatch-neovim'

" Usability             {{{2
Plug 'Konfekt/FastFold'
Plug 'tpope/vim-obsession'

" Pretties              {{{2
Plug 'Yggdroot/indentLine'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'ryanoasis/vim-devicons'

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

set completeopt=menuone,noselect,noinsert

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

inoremap <silent><expr> <C-Space> completion#trigger_completion()

"#############################################################################
"### Plugin settings                                                {{{1    ##
"#############################################################################

"### ALE ###                {{{2
let g:ale_set_loclist = 1
let g:ale_set_quickfix = 0
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_sign_error = ''
let g:ale_sign_style_error = '⚡'
let g:ale_sign_warning = ''
let g:ale_sign_style_warning = ''
let g:ale_sign_info = 'כֿ'

" Autocomplete
let g:ale_completion_enabled = 1

"### Airline ###            {{{2
let g:airline_powerline_fonts = 1
let g:airline#extensions#whitespace#enabled = 0

" Display buffers in tabline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

" Remove icon for total number of lines in buffer
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.maxlinenr = ''

" Don't auto-invoke Tmuxline
let g:airline#extensions#tmuxline#enabled = 0

"### Promptline ###         {{{2
let g:promptline_theme = 'airline'
let g:promptline_preset = {
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
set shortmess+=c
autocmd BufEnter * lua pcall(function() require'completion'.on_attach() end)

let g:diagnostic_enable_virtual_text = 1
let g:diagnostic_virtual_text_prefix = ''

call sign_define("LspDiagnosticsErrorSign", {"text": "", "texthl": "LspDiagnosticsError"})
call sign_define("LspDiagnosticsWarningSign", {"text": "", "texthl": "LspDiagnosticsError"})
call sign_define("LspDiagnosticsInformationSign", {"text": "", "texthl": "LspDiagnosticsError"})
call sign_define("LspDiagnosticsHintSign", {"text": "ﯟ", "texthl": "LspDiagnosticsError"})

runtime nvim-lsp-config.vim

" vim: set fdm=marker: "
