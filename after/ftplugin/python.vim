"
" python.vim
"

inoremap <C-X>l <ESC><C-X>la
nnoremap <C-X>l o#----------------------------------------------------------------------------#<CR><ESC>

inoremap <C-X>L <ESC><C-X>La
nnoremap <C-X>L o    #------------------------------------------------------------------------#<CR><ESC>

inoremap <C-C>t import pdb; pdb.set_trace()<RETURN>
noremap <C-C>t oimport pdb; pdb.set_trace()<RETURN><ESC>

nnoremap <LEADER>n :!nosetests --with-doctest --exe<CR>

set ts=4 sts=4 sw=4 et

" wrap with indent at word boundaries
set bri
set briopt=shift:4
set linebreak

syn keyword larsTodo LARS
