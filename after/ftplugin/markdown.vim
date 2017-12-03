"
"  markdown.md
"

" Borrowed from: https://wynnnetherland.com/linked/2014010902/words-to-avoid-in-tech-writing
"
" Highlight words to avoid in tech writing
" =======================================
"
"   obviously, basically, simply, of course, clearly,
"   just, everyone knows, However, So, easy

"   http://css-tricks.com/words-avoid-educational-writing/

if !exists("*MatchTechWordsToAvoid")
    function MatchTechWordsToAvoid()
        match TechWordsToAvoid /\c\<\(obviously\|basically\|simply\|of\scourse\|clearly\|just\|everyone\sknows\|however\|so,\|easy\)\>/
    endfunction
endif

autocmd FileType markdown call MatchTechWordsToAvoid()
autocmd BufWinEnter *.md call MatchTechWordsToAvoid()
autocmd InsertEnter *.md call MatchTechWordsToAvoid()
autocmd InsertLeave *.md call MatchTechWordsToAvoid()
autocmd BufWinLeave *.md call clearmatches()

highlight TechWordsToAvoid ctermbg=red ctermfg=white

"  wrap to the indent level
set breakindent
