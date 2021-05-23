"
"  init.vim
"
"  Lars Yencken <lars@yencken.org>
"

" LOADING PLUGINS

call plug#begin()

" navigation between files
Plug 'ctrlpvim/ctrlp.vim'

" better git support
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

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

" add ack support
Plug 'mileszs/ack.vim'

" work with matching pairs of brackets or quotes
Plug 'tpope/vim-surround'

" handle more text objects like Python triple quote
Plug 'paradigm/TextObjectify'
Plug 'bps/vim-textobj-python'
Plug 'kana/vim-textobj-user'

" distraction free writing
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'

" Language support for many languages
Plug 'sheerun/vim-polyglot'

" markdown folding
Plug 'masukomi/vim-markdown-folding'

" colorschemes
Plug 'fxn/vim-monochrome'
Plug 'dracula/vim'

" vimwiki
Plug 'larsyencken/vimwiki'

" language server
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'junegunn/fzf'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" uppercase SQL
Plug 'larsyencken/vim-uppercase-sql'

" Python formatting
Plug 'python/black', { 'branch': '19.10b0' }

" GraphQL
Plug 'jparise/vim-graphql'

" Closing windows
Plug 'rbgrouleff/bclose.vim'

" Sneak motion
Plug 'justinmk/vim-sneak'

" Async lint engine (esp. for js)
Plug 'dense-analysis/ale'

" Prettier
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'branch': 'release/0.x'
  \ }

" Pollen for racket
Plug 'otherjoel/vim-pollen'

call plug#end()


" EDITOR SETTINGS

" Use tabstop of 4 by default
set ts=4 sts=4 sw=4 et

" Keep buffers with unsaved changes around in the backgroun
set hidden

" Make search replace all occurrences by default
set gdefault

" Use comma for custom commands
let mapleader = ","

" Close window on ,b
nnoremap <leader>b :Bclose<cr>
nnoremap <leader>B :bd<cr>

" Run make
nnoremap <leader>m :make<cr>

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

" Navigate quickly up and down the quickfix list
nnoremap <C-m> :cn<cr>
nnoremap <C-n> :cb<cr>

set clipboard=unnamed

" Navigate up and down by visual lines, not by newlines
nnoremap j gj
nnoremap k gk

" Use <leader>u to open URLs
function! HandleURL()
  let s:uri = matchstr(getline("."), '[a-z]*:\/\/[^ >,;)]*')
  echo s:uri
  if s:uri != ""
    silent exec "!open '".s:uri."'"
  else
    echo "No URI found in line."
  endif
endfunction
map <leader>u :call HandleURL()<cr>

"colorscheme dracula
set background=dark


" CUSTOMIZE PLUGINS

" Configure ctrl-p plugin for finding files

" ,t to open any file
let g:ctrlp_map = '<leader>t'
" ,f to switch to a file that's already open
nnoremap <leader>f :CtrlPBuffer<cr>
" never include these filetypes in the list
set wildignore+=*.o,*.6,.git,.hg,.svn,*.a,*.so,*.out,*.bbl,*.swp,*.toc,_obj,_test,*-env,*.pyc,*.pyo,*.png,*.jpg,blueprint,*.os,*.gif,*.tar,*.tar.gz,*.tar.bz2,build,dist,*.egg-info,bin,*.class,*.jar,env,lib,__pycache__,tags,elm-stuff,node_modules,plugged,*.mp4,vendor

" Airline
let g:airline_theme= 'serene'

" Jedi
let g:jedi#smart_auto_mappings = 0  " turn off completion of from ... import

" Ack
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
nnoremap <leader>a :Ack <cword><cr>

" Goyo
nnoremap <leader>g :Goyo<cr>
let g:goyo_width=120
let g:goyo_margin_top=1
let g:goyo_margin_bottom=1

" Limelight
let g:limelight_conceal_ctermfg='darkgrey'
nnoremap <leader>l :Limelight!!<cr>

" Vimwiki
"let g:vimwiki_list = [{'path': '~/Documents/lifesum/notes/', 'syntax': 'markdown', 'ext': '.md', 'index': 'Home'}]

" Deoplete
let g:deoplete#enable_at_startup = 1
"let g:python_host_prog = expand('~/.pyenv/versions/neovim2/bin/python')
let g:python3_host_prog = expand('~/.pyenv/versions/neovim3/bin/python')

" Language servers
set hidden

let g:LanguageClient_serverCommands = {
    \'python': [expand('~/.pyenv/versions/neovim3/bin/pyls')],
    \'javascript': ['javascript-typescript-stdio'],
    \'typescript': ['javascript-typescript-stdio']
\}

let g:LanguageClient_settingsPath = expand("~/.config/nvim/settings.json")

nnoremap <F5> :call LanguageClient_contextMenu()<CR>
" Or map each action separately
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

" Quit with :q even in Goyo mode
function! s:goyo_enter()
  let b:quitting = 0
  let b:quitting_bang = 0
  autocmd! QuitPre <buffer> let b:quitting = 1
  cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!
  "autocmd BufWinLeave <buffer> :Goyo
endfunction

function! s:goyo_leave()
  " Quit Vim if this is the only remaining buffer
  if b:quitting && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
    if b:quitting_bang
      qa!
    else
      qa
    endif
  endif
endfunction

autocmd! User GoyoEnter call <SID>goyo_enter()
autocmd! User GoyoLeave call <SID>goyo_leave()

" Automatically reformat Python files on write :D
autocmd BufWritePre *.py execute ':Black'
autocmd BufWritePre *.pyi execute ':Black'

" Autoformat js on write
autocmd BufWritePre *.js execute ':Prettier'

" Eslint
let g:ale_fixers = {
            \ 'javascript': ['eslint'],
            \ 'python': ['black']
            \ }
"let g:ale_sign_error = '❌'
"let g:ale_sign_warning = '⚠️'
let g:ale_fix_on_save = 1

" yank entire file to clipboard
nnoremap <leader>y ggyG

" Snipmate: disable deprecation message
let g:snipMate = { 'snippet_version' : 1 }

" Pollen filetype detection
augroup configgroup
    autocmd!

    "Set Pollen syntax for files with these extensions:
    au! BufRead,BufNewFile *.pm set filetype=pollen
    au! BufRead,BufNewFile *.pmd set filetype=pollen
    au! BufRead,BufNewFile *.pp set filetype=pollen
    au! BufRead,BufNewFile *.ptree set filetype=pollen
    au! BufRead,BufNewFile *.rkt set filetype=racket

    " Suggested editor settings:
    autocmd FileType pollen setlocal wrap      " Soft wrap (don't affect buffer)
    autocmd FileType pollen setlocal linebreak " Wrap on word-breaks only
augroup END

"
" OVERRIDE WITH LOCAL SETTINGS
"

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
