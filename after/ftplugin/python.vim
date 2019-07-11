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

let g:syntastic_python_checkers = ['flake8']

" blacken on write
autocmd BufWritePre *.py execute ':Black'

" ,h to manually blacken a file
nnoremap <leader>h :Black<cr>
