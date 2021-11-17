"
"  vimwiki
"
"  wrap to the indent level
set breakindent

" customize Goyo
let g:goyo_width=80
let g:goyo_margin_top=1
let g:goyo_margin_bottom=1

nnoremap <buffer> <leader>h :%! ~/.config/nvim/scripts/gen-heading "%:t"<cr>

nnoremap <buffer> <leader>, :VimwikiToggleListItem<cr>
