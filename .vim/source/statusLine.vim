"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Status line stuff
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set laststatus=2 "enable status line always
set stl=%f\ %m\ %r%{fugitive#statusline()}\ Line:%l/%L[%p%%]\ Col:%v\ Buf:#%n\ [%b][0x%B]
"set statusline=%F%m%r%h%w\ (%{&ff}){%Y}[%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}
"set statusline=%t[%{strlen(&fenc)?&fenc:'none'},%{&ff}]%h%m%r%y%=%c,%l/%L\ %P

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Stuff to do when inserting and leaving insert mode.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! ModInsertEnter(mode)
    " Recognize words like
    " self.parent
    " /home/wome/.titan
    " Accepted chars: " ' . / [ ] 
    set iskeyword+=34,39,46,47,91,93
    " Change the statusline"
    if a:mode == 'i'
        hi statusline ctermbg=red ctermfg=white
    elseif a:mode == 'r'
        hi statusline ctermbg=red ctermfg=blue
    else
        hi statusline ctermbg=red ctermfg=white
    endif
endfunction

function! ModInsertLeave()
    set iskeyword-=34,39,46,47,91,93
    hi statusline ctermbg=0 ctermfg=15 term=bold,reverse cterm=bold,reverse
endfunction

au InsertEnter * call ModInsertEnter(v:insertmode)
au InsertLeave * call ModInsertLeave()
