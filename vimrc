"
"  .vimrc
"
"  Lars Yencken <lars@yencken.org>
"

" modern filetype detection?
filetype off
filetype plugin indent on

" sensible tab defaults
set ts=4 sts=4 sw=4 et

cnoremap <leader>4 :set<space>ts=4<space>sts=4<space>sw=4<space>et<return>
cnoremap <leader>2 :set<space>ts=2<space>sts=2<space>sw=2<space>et<return>

" disable modelines for security
"set modelines=0

" sensible editing defaults
syntax on
set nocompatible
set nohidden
set incsearch
set encoding=utf-8
set scrolloff=3
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest
set visualbell
set cursorline
set ruler
set backspace=indent,eol,start
set term=xterm-color

"" COOL STUFF FOR VIM 7.3 OR ABOVE
"set relativenumber
"set undofile
set colorcolumn=79
hi ColorColumn ctermbg=lightgrey

" Make commands easier on the fingers
nnoremap ; :

" Better searching
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch
let mapleader = ","
"inoremap ` <esc>
"nnoremap ` <esc>
"vnoremap ` <esc>
nnoremap / /\v
vnoremap / /\v
nnoremap <leader><space> :noh<cr>
nnoremap <tab> %
vnoremap <tab> %

" handle long lines correctly
set wrap
set textwidth=78
set formatoptions=qrn1t

"" FORCE CORRECT NAVIGATION
" scroll by visual lines, not newlines
nnoremap j gj
nnoremap k gk

"" CUSTOM TEXT COMMANDS

" text wrapping
nnoremap <leader>q gqap
" select just-pasted text
nnoremap <leader>v V`]
" pop out of insert mode with jj
inoremap jj <ESC>
" quickfix
nnoremap <leader>m :make<cr>
nnoremap <leader>d :!drake<cr>
nnoremap <leader>c :cc<cr>

" SPLIT WINDOWS
nnoremap <leader>w <C-w>v<C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <leader>b :bd<cr>
nnoremap <leader>s :set filetype=sh<cr>
nnoremap <leader>p :set filetype=python<cr>

" taglist -- navigate between items
nnoremap <leader>r :TlistToggle<cr><C-w>h/function<cr><down>:noh<cr>

" WHAT TO IGNORE
set wildignore+=*.o,*.6,.git,.hg,.svn,*.a,*.so,*.out,*.bbl,*.swp,*.toc,_obj,_test,*-env,*.pyc,*.pyo,*.png,*.jpg,blueprint,*.os,*.gif,*.tar,*.tar.gz,*.tar.bz2,build,dist,*.egg-info,bin,*.class,*.jar,env

" SNIPMATE
let g:snips_author = "Lars Yencken"
let g:snips_owner = "Lars Yencken"

call pathogen#infect()

" Allow customisations for the local machine
let localrc =  expand("~/.vimrc-local")
if filereadable(localrc)
    exe "source " . localrc
endif

" enable pyflakes checking
let g:pcs_check_when_saving = 1

" Use a shared backup directory
set backupdir=~/.vim/backup
set directory=~/.vim/backup

" fugitive: Git integration
" empty statusline is equivalent to:
" set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
set statusline=%<%f\ %{fugitive#statusline()}\ %h%m%r%=%-14.(%l,%c%V%)\ %P

" Using a patched font for powerline
"let g:Powerline_symbols = 'fancy'
"let g:Powerline_theme = 'solarized'
set laststatus=2

" syntastic
set foldlevelstart=99

let g:ctrlp_map = '<leader>t'

" enable clipboard integration
set clipboard=unnamed

" ctrl-p optimisations
" https://gist.github.com/ee14d6ecb9196a07da56
let g:ctrlp_max_files = 10000

" Optimize file searching
if has("unix")
    let g:ctrlp_user_command = {
                \   'types': {
                \       1: ['.git/', 'cd %s && git ls-files']
                \   },
                \   'fallback': 'find %s -type f | head -' . g:ctrlp_max_files
                \ }
endif

" rainbow-parentheses
let g:rbpt_max = 16
let g:rbpt_loadcmd_toggle = 0

au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

let g:markdown_fenced_languages = ['python', 'sql', 'julia']
