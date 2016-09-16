"
"  init.vim
"
"  Lars Yencken <lars@yencken.org>
"

" LOADING PLUGINS

call plug#begin()

" syntax checking
Plug 'scrooloose/syntastic'

" navigation between files
Plug 'ctrlpvim/ctrlp.vim'

" better git support
Plug 'tpope/vim-fugitive'

" better status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" snippets
Plug 'vim-scripts/tlib'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'garbas/vim-snipmate'

" better indending for Python
Plug 'hynek/vim-python-pep8-indent'

" quick commenting and uncommenting
Plug 'scrooloose/nerdcommenter'

" jump to definitions, do refactoring
Plug 'davidhalter/jedi-vim'

" add ack support
Plug 'mileszs/ack.vim'

" work with matching pairs of brackets or quotes
Plug 'tpope/vim-surround'

call plug#end()


" EDITOR SETTINGS

" Use tabstop of 4 by default
set ts=4 sts=4 sw=4 et

" Use comma for custom commands
let mapleader = ","

" Close window on ,b
nnoremap <leader>b :bd<cr>

" Stop highlighting a search on ,_
nnoremap <leader><space> :noh<cr>

set nojoinspaces        " Prevent adding an extra space on join-after-punctuation
set showmatch           " Show matching brackets
set linebreak           " Wrap lines at word boundaries
set cursorline          " Underline the line the cursor is on

" Split windows more easily
nnoremap <leader>w <C-w>v<C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Strip trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

let uname = system("uname -s")

if uname == "Darwin\n"
  " Use system clipboard on OS X
  set clipboard=unnamed
endif

" Navigate up and down by visual lines, not by newlines
nnoremap j gj
nnoremap k gk


" CUSTOMIZE PLUGINS

" Configure ctrl-p plugin for finding files
let g:ctrlp_map = '<leader>t'
nnoremap <leader>f :CtrlPBuffer<cr>
set wildignore+=*.o,*.6,.git,.hg,.svn,*.a,*.so,*.out,*.bbl,*.swp,*.toc,_obj,_test,*-env,*.pyc,*.pyo,*.png,*.jpg,blueprint,*.os,*.gif,*.tar,*.tar.gz,*.tar.bz2,build,dist,*.egg-info,bin,*.class,*.jar,env,__pycache__

" Syntastic
let g:syntastic_auto_loc_list=1
let g:syntastic_auto_jump=1

" Airline
let g:airline_theme= 'serene'

" Jedi
let g:jedi#smart_auto_mappings = 0  " turn off completion of from ... import


" OVERRIDE WITH LOCAL SETTINGS

" Allow customisations for the local machine
let localrc =  expand("~/.config/nvim/init-local.vim")
if filereadable(localrc)
    exe "source " . localrc
endif


"
" RESOURCES
"
" http://nerditya.com/code/guide-to-neovim/
"
