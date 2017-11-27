"
" python.vim
"

setlocal completeopt=menu

" wrap with indent at word boundaries
set bri
set linebreak

" Set a visual limit for Python code at 100 characters wide
set tw=99
set colorcolumn=99
hi ColorColumn ctermbg=darkgrey

" customize Goyo
let g:goyo_width=120
let g:goyo_margin_top=1
let g:goyo_margin_bottom=1
