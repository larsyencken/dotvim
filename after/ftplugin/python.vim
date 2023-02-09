"
"  python.vim
"

autocmd BufWritePre *.py silent execute ':Black'
autocmd BufWritePre *.py silent call isort#Isort(0, line('$'), v:null, v:false)

setlocal foldmethod=indent foldlevel=20
