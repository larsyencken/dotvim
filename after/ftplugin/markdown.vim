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
nnoremap <buffer> <leader>h :%! ~/Documents/lifesum/notes/scripts/gen-heading "%:t"<cr>

nnoremap <buffer> <leader>, :VimwikiToggleListItem<cr>

autocmd FileType markdown set foldexpr=NestedMarkdownFolds()
