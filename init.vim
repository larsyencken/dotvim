"
"  init.vim
"

" LOADING PLUGINS

call plug#begin()

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

set background=dark

"
" faster viewport scrolling
"
nnoremap <c-e> 5<c-e>
nnoremap <c-y> 5<c-y>

"
" CUSTOMIZE PLUGINS
"

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
