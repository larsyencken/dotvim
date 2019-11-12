"
"  markdown.md
"
"  wrap to the indent level
set breakindent

" customize Goyo
let g:goyo_width=80
let g:goyo_margin_top=1
let g:goyo_margin_bottom=1

" Goyo
nnoremap <leader>h :%! ~/Documents/lifesum/notes/scripts/gen-heading "%:t"<cr>

" fast navigation between links
nnoremap <buffer> L /\[\[.<cr>:noh<cr>
nnoremap <buffer> H b?\[\[.<cr>:noh<cr>
