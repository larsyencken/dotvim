" turn-on distraction free writing mode for markdown files

au BufNewFile,BufRead *.{md,mdown,mkd,mkdn,markdown,mdwn} set filetype=mkd syntax=mkd

if has("gui_macvim")
    function! DistractionFreeWriting()
        set filetype=mkd
        "colorscheme iawriter
        set background=dark
        "set gfn=Inconsolata:h19                " font to use
        "set gfn=Inconsolata:h17                " font to use
        set gfn=Source\ Code\ Pro:h15
        set lines=50 columns=80           " size of the editable area
        set fuoptions=background:#00f5f6f6 " macvim specific setting for editor's background color
        set guioptions-=r                  " remove right scrollbar
        set laststatus=0                   " don't show status line
        set noruler                        " don't show ruler
        set fullscreen                     " go to fullscreen editing mode
        set linebreak                      " break the lines on words
        set tw=0
    endfunction
endif
