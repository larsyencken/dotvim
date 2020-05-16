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
let b:ale_linters = ['flake8']

" blacken on write
autocmd BufWritePre *.py execute ':Black'

nnoremap <buffer> <leader>a :call LanguageClient#textDocument_references()<cr>
nnoremap <buffer> <leader>A :Ack <cword><cr>

if isdirectory(".venv") && executable(".venv/bin/pyls")
    let g:LanguageClient_serverCommands = {'python': ['.venv/bin/pyls']}
endif
