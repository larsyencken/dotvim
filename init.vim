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

call plug#end()


" EDITOR SETTINGS

" Use comma for custom commands
let mapleader = ","

" Close window on ,b
nnoremap <leader>b :bd<cr>

set nojoinspaces        " Prevent adding an extra space on join-after-punctuation
set showmatch           " Show matching brackets

" Split windows more easily
nnoremap <leader>w <C-w>v<C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l


" CUSTOMIZE PLUGINS

" Configure ctrl-p plugin for finding files
let g:ctrlp_map = '<leader>t'
nnoremap <leader>f :CtrlPBuffer<cr>
set wildignore+=*.o,*.6,.git,.hg,.svn,*.a,*.so,*.out,*.bbl,*.swp,*.toc,_obj,_test,*-env,*.pyc,*.pyo,*.png,*.jpg,blueprint,*.os,*.gif,*.tar,*.tar.gz,*.tar.bz2,build,dist,*.egg-info,bin,*.class,*.jar,env

" Syntastic
let g:syntastic_auto_loc_list=1
let g:syntastic_auto_jump=1

" Airline
let g:airline_theme= 'serene'


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
